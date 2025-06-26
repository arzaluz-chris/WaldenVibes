//  MeditationView.swift
import SwiftUI

struct MeditationView: View {
    @EnvironmentObject var meditationManager: MeditationManager
    @State private var showingDurationPicker = false
    @State private var animateCircle = false
    
    private let circleSize: CGFloat = 280
    
    var body: some View {
        ZStack {
            // Background with custom image
            Image("MeditationBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .opacity(0.3)
            
            // Gradient overlay
            LinearGradient(
                colors: [
                    Color("AccentColor").opacity(0.1),
                    Color("AccentColor").opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Title
                Text("meditation.title")
                    .font(.largeTitle)
                    .fontWeight(.light)
                
                // Timer Circle
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
                    
                    // Time display
                    VStack(spacing: 8) {
                        Text(meditationManager.formattedTime(from: meditationManager.timeRemaining))
                            .font(.system(size: 48, weight: .light, design: .rounded))
                            .foregroundColor(.primary)
                        
                        if !meditationManager.isActive {
                            Button(action: { showingDurationPicker = true }) {
                                HStack(spacing: 4) {
                                    Text(meditationManager.durationString(for: meditationManager.selectedDuration))
                                        .font(.subheadline)
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                }
                                .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                // Control buttons
                HStack(spacing: 50) {
                    if meditationManager.isActive {
                        // Stop button
                        Button(action: { meditationManager.stop() }) {
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
                            } else {
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
                            meditationManager.start()
                            animateCircle = true
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
                .padding(.top, 20)
                
                // Tips
                if !meditationManager.isActive {
                    MeditationTipsView()
                        .padding(.top)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("nav.meditation")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingDurationPicker) {
            DurationPickerView(selectedDuration: $meditationManager.selectedDuration)
        }
        .onDisappear {
            animateCircle = false
        }
    }
}
