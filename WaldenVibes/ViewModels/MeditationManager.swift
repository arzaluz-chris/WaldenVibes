//  MeditationManager.swift
import Foundation
import SwiftUI
import Combine
import AVFoundation

// MARK: - MeditationManager
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
        
        // Show notification if app is in background
        if UIApplication.shared.applicationState != .active {
            sendCompletionNotification()
        }
    }
    
    // MARK: - Audio
    private func setupAudio() {
        // Configure audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    private func playCompletionSound() {
        // Try to play custom sound first
        if let soundURL = Bundle.main.url(forResource: "MeditationComplete", withExtension: "m4a") {
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
        content.title = NSLocalizedString("meditation.complete.title", comment: "")
        content.body = NSLocalizedString("meditation.complete.body", comment: "")
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "meditation-complete",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
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
            return "1 \(NSLocalizedString("minute", comment: ""))"
        } else {
            return "\(minutes) \(NSLocalizedString("minutes", comment: ""))"
        }
    }
}
