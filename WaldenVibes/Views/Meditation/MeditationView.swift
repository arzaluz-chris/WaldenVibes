// MeditationView.swift - Fixed the complex expression
import SwiftUI
import AVFoundation

struct MeditationView: View {
    @EnvironmentObject var meditationManager: MeditationManager
    @State private var showingDurationPicker = false
    @State private var showingSoundPicker = false
    @State private var animateCircle = false
    @State private var selectedSound: MeditationSound? = nil
    @State private var audioPlayer: AVAudioPlayer?
    
    private let circleSize: CGFloat = 280
    
    enum MeditationSound: String, CaseIterable {
        case none = "None"
        case beach = "Beach"
        case calm = "Calm"
        case jazz = "Jazz"
        case piano = "Piano"
        case tranquility = "Tranquility"
        
        var displayName: String {
            switch self {
            case .none: return "No Sound"
            case .beach: return "Beach Waves"
            case .calm: return "Calm Ambience"
            case .jazz: return "Smooth Jazz"
            case .piano: return "Piano Melody"
            case .tranquility: return "Tranquility"
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
            
            ScrollView {
                VStack(spacing: 40) {
                    // Title with more spacing
                    Text("meditation.title")
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .padding(.top, 20)
                    
                    // Timer Circle
                    timerCircleView
                    
                    // Control buttons
                    controlButtonsView
                        .padding(.top, 20)
                    
                    // Tips
                    if !meditationManager.isActive {
                        MeditationTipsView()
                            .padding(.top)
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
        }
        .navigationTitle("nav.meditation")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingDurationPicker) {
            DurationPickerView(selectedDuration: $meditationManager.selectedDuration)
        }
        .sheet(isPresented: $showingSoundPicker) {
            SoundPickerView(selectedSound: $selectedSound)
        }
        .onDisappear {
            animateCircle = false
            stopMeditationSound()
        }
        .onChange(of: meditationManager.isActive) { isActive in
            if !isActive {
                stopMeditationSound()
            }
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
            if meditationManager.isActive && !meditationManager.isPaused {
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
                            Image(systemName: selectedSound?.icon ?? "speaker.slash.fill")
                                .font(.caption)
                            Text(selectedSound?.displayName ?? "No Sound")
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
                    meditationManager.stop()
                    stopMeditationSound()
                }) {
                    Image(systemName: "stop.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.red.opacity(0.8))
                        .clipShape(Circle())
                }
                
                // Play/Pause button
                Button(action: {
                    if meditationManager.isPaused {
                        meditationManager.resume()
                        resumeMeditationSound()
                    } else {
                        meditationManager.pause()
                        pauseMeditationSound()
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
                    meditationManager.start()
                    animateCircle = true
                    playMeditationSound()
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
        guard let sound = selectedSound, sound != .none else { return }
        
        if let soundURL = Bundle.main.url(forResource: sound.rawValue, withExtension: "m4a") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.numberOfLoops = -1 // Loop indefinitely
                audioPlayer?.play()
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

