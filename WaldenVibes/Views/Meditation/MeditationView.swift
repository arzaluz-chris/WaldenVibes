// WaldenVibes/Views/Meditation/MeditationView.swift
import SwiftUI
import AVFoundation

struct MeditationView: View {
    @EnvironmentObject var meditationManager: MeditationManager
    @State private var showingDurationPicker = false
    @State private var showingSoundPicker = false
    @State private var animateCircle = false
    @State private var animateOrbs = false
    @State private var orbOffset1 = CGSize.zero
    @State private var orbOffset2 = CGSize.zero
    @State private var orbOffset3 = CGSize.zero
    @State private var orbScale1: CGFloat = 1.0
    @State private var orbScale2: CGFloat = 1.0
    @State private var orbScale3: CGFloat = 1.0
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
                    .ignoresSafeArea(.all)
                
                // Orbes animados de fondo para iOS 26
                if animateOrbs {
                    orbsBackground
                        .ignoresSafeArea(.all)
                }

                VStack(spacing: 40) {
                    Spacer()

                    // Timer Circle - centered
                    timerCircleView
                        .padding(.horizontal, 40)

                    Spacer()

                    // Bottom controls - always visible
                    VStack(spacing: 24) {
                        // Control buttons
                        controlButtonsView
                            .opacity(meditationManager.isActive ? 0.7 : 1.0)

                        // Settings row - translúcida cuando está activo
                        HStack(spacing: 16) {
                            // Duration button
                            Button(action: { showingDurationPicker = true }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "timer")
                                        .font(.body)
                                    Text(meditationManager.durationString(for: meditationManager.selectedDuration))
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(.regularMaterial)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(LinearGradient(
                                            colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ), lineWidth: 0.5)
                                )
                                .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                            }
                            .disabled(meditationManager.isActive)

                            // Sound button
                            Button(action: { showingSoundPicker = true }) {
                                HStack(spacing: 8) {
                                    Image(systemName: selectedSound.icon)
                                        .font(.body)
                                    Text(selectedSound.displayName)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .lineLimit(1)
                                }
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(.regularMaterial)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(LinearGradient(
                                            colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ), lineWidth: 0.5)
                                )
                                .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                            }
                            .disabled(meditationManager.isActive)
                        }
                        .padding(.horizontal, 24)
                        .opacity(meditationManager.isActive ? 0.4 : 1.0)
                    }
                    .padding(.vertical, 32)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
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
                    startOrbAnimations()
                    playMeditationSound()
                } else {
                    animateCircle = false
                    stopOrbAnimations()
                    stopMeditationSound()
                }
            }
            .onChange(of: meditationManager.isPaused) { _, isPaused in
                if isPaused {
                    pauseOrbAnimations()
                    pauseMeditationSound()
                } else if meditationManager.isActive {
                    resumeOrbAnimations()
                    resumeMeditationSound()
                }
            }
        } else {
            // MARK: - iOS 18 Design
            ZStack {
                // Background
                backgroundView

                GeometryReader { geometry in
                    VStack(spacing: 30) {
                        // Add spacer to push content down
                        Spacer()
                            .frame(height: geometry.size.height * 0.1) // 10% of screen height

                        // Title centered in available space con glassmorphism
                        VStack {
                            Text("Time to Meditate", comment: "Meditation screen title")
                                .font(horizontalSizeClass == .regular ? .system(size: 48, weight: .light) : .largeTitle)
                                .fontWeight(.light)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.thinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.white.opacity(0.3), .white.opacity(0.1)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
                        )

                        Spacer()
                            .frame(height: 20)

                        // Timer Circle - centered vertically
                        timerCircleView

                        Spacer()
                            .frame(height: 30)

                        // Control buttons
                        controlButtonsView

                        // Bottom spacer
                        Spacer()
                            .frame(height: geometry.size.height * 0.15) // 15% of screen height
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
                    startOrbAnimations()
                    playMeditationSound()
                } else {
                    animateCircle = false
                    stopOrbAnimations()
                    stopMeditationSound()
                }
            }
            .onChange(of: meditationManager.isPaused) { _, isPaused in
                if isPaused {
                    pauseOrbAnimations()
                    pauseMeditationSound()
                } else if meditationManager.isActive {
                    resumeOrbAnimations()
                    resumeMeditationSound()
                }
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
            // Fondo base con imagen
            Image("MeditationBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: UIScreen.main.bounds.width, 
                       minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea(.all)
                .opacity(0.6)
            
            // Capa de glassmorphism uniforme
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(.all)
                .overlay(
                    LinearGradient(
                        colors: [
                            Color("AccentColor").opacity(0.15),
                            Color("AccentColor").opacity(0.25),
                            Color("AccentColor").opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Orbes animados de fondo
            if animateOrbs {
                orbsBackground
                    .ignoresSafeArea(.all)
            }
        }
    }
    
    private var timerCircleView: some View {
        ZStack {
            // Background circle with glassmorphic effect
            Circle()
                .stroke(
                    Color("AccentColor").opacity(0.15),
                    lineWidth: 16
                )
                .frame(width: circleSize, height: circleSize)

            // Progress circle
            Circle()
                .trim(from: 0, to: meditationManager.progress)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color("AccentColor"),
                            Color("AccentColor").opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(
                        lineWidth: 16,
                        lineCap: .round
                    )
                )
                .frame(width: circleSize, height: circleSize)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.1), value: meditationManager.progress)
                .shadow(color: Color("AccentColor").opacity(0.3), radius: 8, x: 0, y: 4)

            // Animated breathing circles
            if meditationManager.isActive && !meditationManager.isPaused && animateCircle {
                animatedCircles
            }

            // Time display
            VStack(spacing: 4) {
                Text(meditationManager.formattedTime(from: meditationManager.timeRemaining))
                    .font(.system(size: horizontalSizeClass == .regular ? 72 : 56, weight: .thin, design: .rounded))
                    .foregroundColor(.primary)
                    .monospacedDigit()

                if meditationManager.isActive {
                    Text(meditationManager.isPaused ? "Paused" : "Breathe")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .tracking(2)
                }
            }
        }
    }
    
    private var animatedCircles: some View {
        ForEach(0..<3) { index in
            Circle()
                .stroke(
                    Color("AccentColor").opacity(0.2),
                    lineWidth: 1.5
                )
                .frame(
                    width: circleSize + CGFloat(index * 50),
                    height: circleSize + CGFloat(index * 50)
                )
                .scaleEffect(animateCircle ? 1.15 : 1.0)
                .opacity(animateCircle ? 0 : 0.4)
                .animation(
                    Animation.easeInOut(duration: 5)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.7),
                    value: animateCircle
                )
        }
    }
    
    // MARK: - Orbes animados de fondo
    private var orbsBackground: some View {
        ZStack {
            // Orbe 1 - Grande y lento
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color("AccentColor").opacity(0.15),
                            Color("AccentColor").opacity(0.05),
                            .clear
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)
                .scaleEffect(orbScale1)
                .offset(orbOffset1)
                .blur(radius: 2)
            
            // Orbe 2 - Mediano
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color("AccentColor").opacity(0.2),
                            Color("AccentColor").opacity(0.08),
                            .clear
                        ],
                        center: .center,
                        startRadius: 5,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .scaleEffect(orbScale2)
                .offset(orbOffset2)
                .blur(radius: 1.5)
            
            // Orbe 3 - Pequeño y rápido
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color("AccentColor").opacity(0.25),
                            Color("AccentColor").opacity(0.1),
                            .clear
                        ],
                        center: .center,
                        startRadius: 3,
                        endRadius: 50
                    )
                )
                .frame(width: 100, height: 100)
                .scaleEffect(orbScale3)
                .offset(orbOffset3)
                .blur(radius: 1)
        }
    }
    
    @ViewBuilder
    private var controlButtonsView: some View {
        if #available(iOS 26.0, *) {
            HStack(spacing: 24) {
                if meditationManager.isActive {
                    // Stop button
                    Button(action: {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedback.impactOccurred()
                        meditationManager.stop()
                        stopMeditationSound()
                    }) {
                        ZStack {
                            Circle()
                                .fill(.regularMaterial)
                                .frame(width: 64, height: 64)
                                .overlay(
                                    Circle()
                                        .stroke(LinearGradient(
                                            colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ), lineWidth: 1)
                                )
                                .shadow(color: Color.red.opacity(0.2), radius: 12, x: 0, y: 4)

                            Image(systemName: "stop.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.red)
                        }
                    }

                    // Play/Pause button (larger, primary)
                    Button(action: {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        if meditationManager.isPaused {
                            meditationManager.resume()
                        } else {
                            meditationManager.pause()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(.regularMaterial)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Circle()
                                        .stroke(LinearGradient(
                                            colors: [.white.opacity(0.6), .white.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ), lineWidth: 1.5)
                                )
                                .shadow(color: Color("AccentColor").opacity(0.3), radius: 16, x: 0, y: 6)

                            Image(systemName: meditationManager.isPaused ? "play.fill" : "pause.fill")
                                .font(.system(size: 28))
                                .foregroundColor(Color("AccentColor"))
                        }
                    }

                    // Invisible spacer for balance
                    Circle()
                        .fill(.clear)
                        .frame(width: 64, height: 64)
                } else {
                    // Start button (centered, large)
                    Button(action: {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedback.impactOccurred()
                        meditationManager.start()
                    }) {
                        ZStack {
                            Circle()
                                .fill(.regularMaterial)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Circle()
                                        .stroke(LinearGradient(
                                            colors: [.white.opacity(0.6), .white.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ), lineWidth: 1.5)
                                )
                                .shadow(color: Color("AccentColor").opacity(0.3), radius: 16, x: 0, y: 6)

                            Image(systemName: "play.fill")
                                .font(.system(size: 28))
                                .foregroundColor(Color("AccentColor"))
                        }
                    }
                }
            }
        } else {
            HStack(spacing: 50) {
                if meditationManager.isActive {
                    // Stop button con glassmorphism
                    Button(action: {
                        // Haptic feedback for stopping meditation
                        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedback.impactOccurred()

                        meditationManager.stop()
                        stopMeditationSound()
                    }) {
                        ZStack {
                            Circle()
                                .fill(.regularMaterial)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [.white.opacity(0.4), .white.opacity(0.1)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(color: Color.red.opacity(0.3), radius: 15, x: 0, y: 8)
                            
                            Image(systemName: "stop.fill")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                    }

                    // Play/Pause button con glassmorphism
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
                        ZStack {
                            Circle()
                                .fill(.regularMaterial)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [.white.opacity(0.5), .white.opacity(0.2)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )
                                )
                                .shadow(color: Color("AccentColor").opacity(0.4), radius: 15, x: 0, y: 8)
                            
                            Image(systemName: meditationManager.isPaused ? "play.fill" : "pause.fill")
                                .font(.title)
                                .foregroundColor(Color("AccentColor"))
                        }
                    }
                } else {
                    // Start button con glassmorphism
                    Button(action: {
                        // Haptic feedback for starting meditation
                        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedback.impactOccurred()

                        meditationManager.start()
                    }) {
                        ZStack {
                            Circle()
                                .fill(.regularMaterial)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [.white.opacity(0.5), .white.opacity(0.2)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )
                                )
                                .shadow(color: Color("AccentColor").opacity(0.4), radius: 15, x: 0, y: 8)
                            
                            Image(systemName: "play.fill")
                                .font(.title)
                                .foregroundColor(Color("AccentColor"))
                        }
                    }
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
    
    // MARK: - Orb Animation Management
    private func startOrbAnimations() {
        withAnimation(.easeInOut(duration: 0.8)) {
            animateOrbs = true
        }
        
        // Animación del orbe 1 - Movimiento lento y suave
        withAnimation(
            Animation.easeInOut(duration: 8)
                .repeatForever(autoreverses: true)
        ) {
            orbOffset1 = CGSize(width: 60, height: -80)
            orbScale1 = 1.2
        }
        
        // Animación del orbe 2 - Movimiento mediano
        withAnimation(
            Animation.easeInOut(duration: 6)
                .repeatForever(autoreverses: true)
                .delay(1)
        ) {
            orbOffset2 = CGSize(width: -70, height: 90)
            orbScale2 = 1.1
        }
        
        // Animación del orbe 3 - Movimiento rápido
        withAnimation(
            Animation.easeInOut(duration: 4)
                .repeatForever(autoreverses: true)
                .delay(0.5)
        ) {
            orbOffset3 = CGSize(width: 50, height: 60)
            orbScale3 = 1.3
        }
    }
    
    private func pauseOrbAnimations() {
        // Las animaciones se mantienen pero se detienen visualmente
        withAnimation(.easeOut(duration: 0.5)) {
            orbScale1 = 0.8
            orbScale2 = 0.8
            orbScale3 = 0.8
        }
    }
    
    private func resumeOrbAnimations() {
        // Reanudar las animaciones con transición suave
        withAnimation(.easeIn(duration: 0.5)) {
            orbScale1 = 1.2
            orbScale2 = 1.1
            orbScale3 = 1.3
        }
    }
    
    private func stopOrbAnimations() {
        withAnimation(.easeOut(duration: 0.8)) {
            animateOrbs = false
            orbOffset1 = .zero
            orbOffset2 = .zero
            orbOffset3 = .zero
            orbScale1 = 1.0
            orbScale2 = 1.0
            orbScale3 = 1.0
        }
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
