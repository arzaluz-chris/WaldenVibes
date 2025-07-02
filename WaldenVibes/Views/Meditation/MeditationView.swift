// WaldenVibes/Views/Meditation/MeditationView.swift
import SwiftUI
import AVFoundation

struct MeditationView: View {
    @EnvironmentObject var meditationManager: MeditationManager
    @State private var showingDurationPicker = false
    @State private var showingSoundPicker = false
    @State private var animateCircle = false
    @AppStorage("selectedMeditationSound") private var selectedSoundRawValue = "none"
    @State private var audioPlayer: AVAudioPlayer?
    
    private let circleSize: CGFloat = 280
    
    private var selectedSound: MeditationSound {
        MeditationSound(rawValue: selectedSoundRawValue) ?? .none
    }
    
    enum MeditationSound: String, CaseIterable {
        case none = "none"
        case beach = "Beach"
        case calm = "Calm"
        case jazz = "Jazz"
        case piano = "Piano"
        case tranquility = "Tranquility"
        
        var displayName: String {
            switch self {
            case .none: return String(localized: "No Sound", comment: "Option for no meditation sound")
            case .beach: return String(localized: "Beach Waves", comment: "Beach waves meditation sound")
            case .calm: return String(localized: "Calm Ambience", comment: "Calm ambience meditation sound")
            case .jazz: return String(localized: "Smooth Jazz", comment: "Jazz meditation sound")
            case .piano: return String(localized: "Piano Melody", comment: "Piano meditation sound")
            case .tranquility: return String(localized: "Tranquility", comment: "Tranquility meditation sound")
            }
        }
        
        var icon: String {
            switch self {
            case .none: return "speaker.slash.fill"
            case .beach: return "water.waves"
            case .calm: return "leaf.fill"
            case .jazz: return "music.note"
            case .piano: return "pianokeys"
            case .tranquility: return "sparkles"
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            backgroundView
            
            GeometryReader { geometry in
                VStack(spacing: 30) {
                    // Add spacer to push content down
                    Spacer()
                        .frame(height: geometry.size.height * 0.1) // 10% of screen height
                    
                    // Title centered in available space
                    Text("Time to Meditate", comment: "Meditation screen title")
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Timer Circle - centered vertically
                    timerCircleView
                    
                    Spacer()
                        .frame(height: 30)
                    
                    // Control buttons
                    controlButtonsView
                    
                    // Tips (only when not active)
                    if !meditationManager.isActive {
                        MeditationTipsView()
                            .padding(.top, 20)
                    }
                    
                    // Bottom spacer
                    Spacer()
                        .frame(height: geometry.size.height * 0.1) // 10% of screen height
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackgroundHidden()
        .sheet(isPresented: $showingDurationPicker) {
            DurationPickerView(selectedDuration: $meditationManager.selectedDuration)
        }
        .sheet(isPresented: $showingSoundPicker) {
            SoundPickerView(selectedSound: Binding(
                get: { selectedSound },
                set: { newValue in selectedSoundRawValue = newValue.rawValue }
            ))
        }
        .onAppear {
            setupBackgroundAudio()
        }
        .onChange(of: meditationManager.isActive) { _, isActive in
            if isActive {
                withAnimation(.easeInOut(duration: 1)) {
                    animateCircle = true
                }
                playMeditationSound()
            } else {
                animateCircle = false
                stopMeditationSound()
            }
        }
        .onChange(of: meditationManager.isPaused) { _, isPaused in
            if isPaused {
                pauseMeditationSound()
            } else if meditationManager.isActive {
                resumeMeditationSound()
            }
        }
    }
    
    // MARK: - Audio Setup
    private func setupBackgroundAudio() {
        do {
            // Configure audio session for background playback and to override silent mode
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.allowBluetooth, .allowBluetoothA2DP, .allowAirPlay, .mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    // MARK: - Subviews
    private var backgroundView: some View {
        ZStack {
            Image("MeditationBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .opacity(0.3)
            
            LinearGradient(
                colors: [
                    Color("AccentColor").opacity(0.1),
                    Color("AccentColor").opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
    
    private var timerCircleView: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(
                    Color("AccentColor").opacity(0.2),
                    lineWidth: 20
                )
                .frame(width: circleSize, height: circleSize)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: meditationManager.progress)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color("AccentColor"),
                            Color("AccentColor").opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
                .frame(width: circleSize, height: circleSize)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.1), value: meditationManager.progress)
            
            // Animated circles
            if meditationManager.isActive && !meditationManager.isPaused && animateCircle {
                animatedCircles
            }
            
            // Time display
            timeDisplayView
        }
    }
    
    private var animatedCircles: some View {
        ForEach(0..<3) { index in
            Circle()
                .stroke(
                    Color("AccentColor").opacity(0.3),
                    lineWidth: 2
                )
                .frame(
                    width: circleSize + CGFloat(index * 40),
                    height: circleSize + CGFloat(index * 40)
                )
                .scaleEffect(animateCircle ? 1.1 : 1.0)
                .opacity(animateCircle ? 0 : 0.5)
                .animation(
                    Animation.easeInOut(duration: 4)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.5),
                    value: animateCircle
                )
        }
    }
    
    private var timeDisplayView: some View {
        VStack(spacing: 8) {
            Text(meditationManager.formattedTime(from: meditationManager.timeRemaining))
                .font(.system(size: 48, weight: .light, design: .rounded))
                .foregroundColor(.primary)
            
            if !meditationManager.isActive {
                VStack(spacing: 12) {
                    Button(action: { showingDurationPicker = true }) {
                        HStack(spacing: 4) {
                            Text(meditationManager.durationString(for: meditationManager.selectedDuration))
                                .font(.subheadline)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Button(action: { showingSoundPicker = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: selectedSound.icon)
                                .font(.caption)
                            Text(selectedSound.displayName)
                                .font(.subheadline)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var controlButtonsView: some View {
        HStack(spacing: 50) {
            if meditationManager.isActive {
                // Stop button
                Button(action: {
                    // Haptic feedback for stopping meditation
                    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                    impactFeedback.impactOccurred()
                    
                    meditationManager.stop()
                    stopMeditationSound()
                }) {
                    Image(systemName: "stop.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background(Color.red.opacity(0.8))
                        .clipShape(Circle())
                }
                
                // Play/Pause button
                Button(action: {
                    if meditationManager.isPaused {
                        // Haptic feedback for resuming meditation
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        
                        meditationManager.resume()
                    } else {
                        // Haptic feedback for pausing meditation
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        
                        meditationManager.pause()
                    }
                }) {
                    Image(systemName: meditationManager.isPaused ? "play.fill" : "pause.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background(Color("AccentColor"))
                        .clipShape(Circle())
                }
            } else {
                // Start button
                Button(action: {
                    // Haptic feedback for starting meditation
                    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                    impactFeedback.impactOccurred()
                    
                    meditationManager.start()
                }) {
                    Image(systemName: "play.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background(Color("AccentColor"))
                        .clipShape(Circle())
                        .shadow(color: Color("AccentColor").opacity(0.3), radius: 10, x: 0, y: 5)
                }
            }
        }
    }
    
    // MARK: - Sound Management
    private func playMeditationSound() {
        guard selectedSound != .none else { return }
        
        if let soundURL = Bundle.main.url(forResource: selectedSound.rawValue, withExtension: "m4a") {
            do {
                // Stop any existing player
                audioPlayer?.stop()
                
                // Create new audio player
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.numberOfLoops = -1 // Loop indefinitely
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                
                // Configure to play even when app is in background
                try AVAudioSession.sharedInstance().setActive(true)
                
            } catch {
                print("Failed to play meditation sound: \(error)")
            }
        }
    }
    
    private func pauseMeditationSound() {
        audioPlayer?.pause()
    }
    
    private func resumeMeditationSound() {
        audioPlayer?.play()
    }
    
    private func stopMeditationSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}

// Navigation bar background hidden extension
extension View {
    func navigationBarBackgroundHidden() -> some View {
        self.modifier(NavigationBarBackgroundHiddenModifier())
    }
}

struct NavigationBarBackgroundHiddenModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}
