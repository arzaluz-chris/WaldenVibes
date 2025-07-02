// WaldenVibes/ViewModels/MeditationManager.swift
import Foundation
import SwiftUI
import Combine
import AVFoundation
import UserNotifications

class MeditationManager: ObservableObject {
    // Published properties
    @Published var timeRemaining: TimeInterval = 0
    @Published var isActive = false
    @Published var isPaused = false
    @Published var selectedDuration: TimeInterval = 300 // 5 minutes default
    @Published var progress: Double = 0
    
    // Timer
    private var timer: Timer?
    private var startTime: Date?
    private var pausedTime: TimeInterval = 0
    private var totalPausedDuration: TimeInterval = 0
    
    // Audio player for completion sound
    private var audioPlayer: AVAudioPlayer?
    
    // Predefined durations (in seconds)
    static let durations: [TimeInterval] = [60, 180, 300, 600, 900, 1200] // 1, 3, 5, 10, 15, 20 minutes
    
    init() {
        setupAudio()
        setupBackgroundAudio()
    }
    
    // MARK: - Timer Controls
    func start() {
        guard !isActive else { return }
        
        isActive = true
        isPaused = false
        startTime = Date()
        timeRemaining = selectedDuration
        totalPausedDuration = 0
        
        startTimer()
    }
    
    func pause() {
        guard isActive && !isPaused else { return }
        
        isPaused = true
        pausedTime = Date().timeIntervalSince1970
        timer?.invalidate()
    }
    
    func resume() {
        guard isActive && isPaused else { return }
        
        let pauseDuration = Date().timeIntervalSince1970 - pausedTime
        totalPausedDuration += pauseDuration
        isPaused = false
        
        startTimer()
    }
    
    func stop() {
        timer?.invalidate()
        isActive = false
        isPaused = false
        timeRemaining = 0
        progress = 0
        startTime = nil
        totalPausedDuration = 0
    }
    
    // MARK: - Private Methods
    private func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateTimer()
        }
    }
    
    private func updateTimer() {
        guard let startTime = startTime else { return }
        
        let elapsed = Date().timeIntervalSince(startTime) - totalPausedDuration
        timeRemaining = max(0, selectedDuration - elapsed)
        progress = min(1, elapsed / selectedDuration)
        
        if timeRemaining <= 0 {
            complete()
        }
    }
    
    private func complete() {
        stop()
        playCompletionSound()
        
        // Trigger haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Send completion notification
        sendCompletionNotification()
    }
    
    // MARK: - Audio Setup
    private func setupAudio() {
        // Configure audio session for background playback and override silent mode
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.allowBluetooth, .allowBluetoothA2DP, .allowAirPlay]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    private func setupBackgroundAudio() {
        // This will be handled in the app delegate or scene delegate
        // for now we ensure the audio session is properly configured
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRouteChange),
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )
    }
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            // Interruption began - pause if needed
            if isActive && !isPaused {
                pause()
            }
        case .ended:
            // Interruption ended - resume if we were active
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) && isActive && isPaused {
                    resume()
                }
            }
        @unknown default:
            break
        }
    }
    
    @objc private func handleRouteChange(notification: Notification) {
        // Handle route changes (headphones plugged/unplugged, etc.)
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        
        switch reason {
        case .oldDeviceUnavailable:
            // Headphones were unplugged - pause meditation
            if isActive && !isPaused {
                pause()
            }
        default:
            break
        }
    }
    
    private func playCompletionSound() {
        // Play custom completion sound
        if let soundURL = Bundle.main.url(forResource: "MeditationComplete", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                // Fallback to system sound
                AudioServicesPlaySystemSound(1005)
            }
        } else {
            // Fallback to system sound
            AudioServicesPlaySystemSound(1005)
        }
    }
    
    // MARK: - Notifications
    private func sendCompletionNotification() {
        let content = UNMutableNotificationContent()
        
        // Add some zen emojis for a relaxing feel
        let relaxingEmojis = ["🧘‍♀️", "🌸", "🌿", "✨", "🌙", "🕯️", "🦋", "🌺"]
        let randomEmoji = relaxingEmojis.randomElement() ?? "🧘‍♀️"
        
        content.title = String(localized: "\(randomEmoji) Meditation Complete!", comment: "Meditation completion notification title with emoji")
        content.body = String(localized: "Well done! You've completed your meditation session. \(randomEmoji)", comment: "Meditation completion notification body with emoji")
        
        // Use custom notification sound if available
        if Bundle.main.url(forResource: "Notification", withExtension: "mp3") != nil {
            content.sound = UNNotificationSound(named: UNNotificationSoundName("Notification.mp3"))
        } else {
            content.sound = .default
        }
        
        let request = UNNotificationRequest(
            identifier: "meditation-complete-\(UUID().uuidString)",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending meditation completion notification: \(error)")
            }
        }
    }
    
    // MARK: - Helper Methods
    func formattedTime(from seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func durationString(for seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        if minutes == 1 {
            return String(localized: "1 minute", comment: "Duration in singular minute")
        } else {
            return String(localized: "\(minutes) minutes", comment: "Duration in plural minutes")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
