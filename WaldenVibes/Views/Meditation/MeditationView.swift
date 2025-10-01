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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    private var circleSize: CGFloat {
        horizontalSizeClass == .regular ? 400 : 280
    }
    
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
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            ZStack {
                // Animated glass background
                AnimatedGlassBackground(color: Color("AccentColor"))
                
                GeometryReader { geometry in
                    VStack(spacing: 30) {
                        Spacer().frame(height: geometry.size.height * 0.1)
                        
                        Text("Time to Meditate", comment: "Meditation screen title")
                            .font(horizontalSizeClass == .regular ? .system(size: 48, weight: .light) : .largeTitle)
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer().frame(height: 20)
                        
                        timerCircleView
                        
                        Spacer().frame(height: 30)
                        
                        controlButtonsView
                        
                        Spacer().frame(height: geometry.size.height * 0.15)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: $showingDurationPicker) { DurationPickerView(selectedDuration: $meditationManager.selectedDuration) }
            .sheet(isPresented: $showingSoundPicker) {
                SoundPickerView(selectedSound: Binding(
                    get: { selectedSound },
                    set: { newValue in selectedSoundRawValue = newValue.rawValue }
                ))
            }
            .onAppear(perform: setupAudioAndAnimation)
            .onChange(of: meditationManager.isActive, perform: handleActiveChange)
            .onChange(of: meditationManager.isPaused, perform: handlePauseChange)

        } else {
            // MARK: - iOS 18 Design
            ZStack {
                backgroundView
                
                GeometryReader { geometry in
                    VStack(spacing: 30) {
                        Spacer().frame(height: geometry.size.height * 0.1)
                        Text("Time to Meditate", comment: "Meditation screen title")
                            .font(horizontalSizeClass == .regular ? .system(size: 48, weight: .light) : .largeTitle)
                            .fontWeight(.light).multilineTextAlignment(.center).padding(.horizontal)
                        Spacer().frame(height: 20)
                        timerCircleView
                        Spacer().frame(height: 30)
                        controlButtonsView
                        Spacer().frame(height: geometry.size.height * 0.15)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("").navigationBarTitleDisplayMode(.inline).navigationBarBackgroundHidden()
            .sheet(isPresented: $showingDurationPicker) { DurationPickerView(selectedDuration: $meditationManager.selectedDuration) }
            .sheet(isPresented: $showingSoundPicker) {
                SoundPickerView(selectedSound: Binding(
                    get: { selectedSound },
                    set: { newValue in selectedSoundRawValue = newValue.rawValue }
                ))
            }
            .onAppear { setupBackgroundAudio() }
            .onChange(of: meditationManager.isActive) { _, isActive in
                if isActive { withAnimation(.easeInOut(duration: 1)) { animateCircle = true }; playMeditationSound() }
                else { animateCircle = false; stopMeditationSound() }
            }
            .onChange(of: meditationManager.isPaused) { _, isPaused in
                if isPaused { pauseMeditationSound() } else if meditationManager.isActive { resumeMeditationSound() }
            }
        }
    }

    // MARK: - iOS 26 Setup
    private func setupAudioAndAnimation() {
        setupBackgroundAudio()
        if meditationManager.isActive {
            animateCircle = true
        }
    }

    private func handleActiveChange(newValue: Bool) {
        if newValue {
            withAnimation(.easeInOut(duration: 1)) { animateCircle = true }
            playMeditationSound()
        } else {
            animateCircle = false
            stopMeditationSound()
        }
    }

    private func handlePauseChange(newValue: Bool) {
        if newValue {
            pauseMeditationSound()
        } else if meditationManager.isActive {
            resumeMeditationSound()
        }
    }
    
    // MARK: - Subviews
    private var backgroundView: some View {
        ZStack {
            Image("MeditationBackground")
                .resizable().aspectRatio(contentMode: .fill).ignoresSafeArea().opacity(0.3)
            LinearGradient(colors: [Color("AccentColor").opacity(0.1), Color("AccentColor").opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        }
    }
    
    private var timerCircleView: some View {
        ZStack {
            if #available(iOS 26.0, *) {
                // Glassmorphism background for the circle
                Circle()
                    .fill(.regularMaterial)
                    .frame(width: circleSize, height: circleSize)
                    .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 1))
                    .shadow(radius: 20)
            } else {
                Circle().stroke(Color("AccentColor").opacity(0.2), lineWidth: 20)
                    .frame(width: circleSize, height: circleSize)
            }
            
            // Progress circle
            Circle()
                .trim(from: 0, to: meditationManager.progress)
                .stroke(
                    LinearGradient(colors: [Color("AccentColor"), Color("AccentColor").opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                )
                .frame(width: circleSize, height: circleSize)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.1), value: meditationManager.progress)
            
            // Animated circles
            if meditationManager.isActive && !meditationManager.isPaused && animateCircle {
                animatedCircles
            }
            
            timeDisplayView
        }
    }
    
    private var animatedCircles: some View {
        ForEach(0..<3) { index in
            Circle()
                .stroke(Color("AccentColor").opacity(0.3), lineWidth: 2)
                .frame(width: circleSize + CGFloat(index * 40), height: circleSize + CGFloat(index * 40))
                .scaleEffect(animateCircle ? 1.1 : 1.0)
                .opacity(animateCircle ? 0 : 0.5)
                .animation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: false).delay(Double(index) * 0.5), value: animateCircle)
        }
    }
    
    private var timeDisplayView: some View {
        VStack(spacing: 8) {
            Text(meditationManager.formattedTime(from: meditationManager.timeRemaining))
                .font(.system(size: horizontalSizeClass == .regular ? 64 : 48, weight: .light, design: .rounded))
                .foregroundColor(.primary)
            
            if !meditationManager.isActive {
                VStack(spacing: 12) {
                    Button(action: { showingDurationPicker = true }) {
                        HStack(spacing: 4) {
                            Text(meditationManager.durationString(for: meditationManager.selectedDuration)).font(.subheadline)
                            Image(systemName: "chevron.down").font(.caption)
                        }.foregroundColor(.secondary)
                    }
                    
                    Button(action: { showingSoundPicker = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: selectedSound.icon).font(.caption)
                            Text(selectedSound.displayName).font(.subheadline)
                            Image(systemName: "chevron.down").font(.caption)
                        }.foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var controlButtonsView: some View {
        HStack(spacing: 50) {
            if meditationManager.isActive {
                // Stop button
                controlButton(systemName: "stop.fill", color: .red.opacity(0.8)) {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                    impactFeedback.impactOccurred()
                    meditationManager.stop()
                    stopMeditationSound()
                }
                
                // Play/Pause button
                controlButton(systemName: meditationManager.isPaused ? "play.fill" : "pause.fill", color: Color("AccentColor")) {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    if meditationManager.isPaused { meditationManager.resume() } else { meditationManager.pause() }
                }
            } else {
                // Start button
                controlButton(systemName: "play.fill", color: Color("AccentColor")) {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                    impactFeedback.impactOccurred()
                    meditationManager.start()
                }
            }
        }
    }

    @ViewBuilder
    private func controlButton(systemName: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(
                    ZStack {
                        if #available(iOS 26.0, *) {
                            color
                                .background(.regularMaterial)
                                .clipShape(Circle())
                                .shadow(color: color.opacity(0.4), radius: 10, y: 5)
                                .overlay(Circle().stroke(.white.opacity(0.3), lineWidth: 1))
                        } else {
                            color.clipShape(Circle())
                        }
                    }
                )
        }
    }
    
    // MARK: - Audio and Sound Management
    private func setupBackgroundAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP, .allowAirPlay, .mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch { print("Failed to configure audio session: \(error)") }
    }
    
    private func playMeditationSound() {
        guard selectedSound != .none, let soundURL = Bundle.main.url(forResource: selectedSound.rawValue, withExtension: "m4a") else { return }
        do {
            audioPlayer?.stop()
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            try AVAudioSession.sharedInstance().setActive(true)
        } catch { print("Failed to play meditation sound: \(error)") }
    }
    
    private func pauseMeditationSound() { audioPlayer?.pause() }
    private func resumeMeditationSound() { audioPlayer?.play() }
    private func stopMeditationSound() { audioPlayer?.stop(); audioPlayer = nil }
}

// Navigation bar background hidden extension
extension View {
    func navigationBarBackgroundHidden() -> some View {
        self.modifier(NavigationBarBackgroundHiddenModifier())
    }
}

struct NavigationBarBackgroundHiddenModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
