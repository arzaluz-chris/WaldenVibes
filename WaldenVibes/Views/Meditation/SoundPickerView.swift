// WaldenVibes/Views/Meditation/SoundPickerView.swift
import SwiftUI
import AVFoundation

struct SoundPickerView: View {
    @Binding var selectedSound: MeditationView.MeditationSound
    @Environment(\.dismiss) var dismiss
    @State private var previewPlayer: AVAudioPlayer?
    @State private var currentlyPreviewing: MeditationView.MeditationSound?
    @State private var previewTimer: Timer?
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(MeditationView.MeditationSound.allCases, id: \.self) { sound in
                    HStack {
                        Image(systemName: sound.icon)
                            .font(.title2)
                            .foregroundColor(Color("AccentColor"))
                            .frame(width: 40)
                        
                        VStack(alignment: .leading) {
                            Text(sound.displayName)
                                .font(.body)
                        }
                        
                        Spacer()
                        
                        // Preview button with animation
                        if sound != .none {
                            Button(action: {
                                if currentlyPreviewing == sound {
                                    stopPreview()
                                } else {
                                    previewSound(sound)
                                }
                            }) {
                                ZStack {
                                    // Background circle for animation
                                    if currentlyPreviewing == sound {
                                        Circle()
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                                            .frame(width: 35, height: 35)
                                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                                            .opacity(isAnimating ? 0 : 1)
                                            .animation(
                                                Animation.easeInOut(duration: 1.5)
                                                    .repeatForever(autoreverses: false),
                                                value: isAnimating
                                            )
                                    }
                                    
                                    Image(systemName: currentlyPreviewing == sound ? "stop.circle.fill" : "play.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        
                        if selectedSound == sound {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color("AccentColor"))
                                .fontWeight(.semibold)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedSound = sound
                        stopPreview()
                        dismiss()
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Sound")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done") {
                        stopPreview()
                        dismiss()
                    }
                }
            }
        }
        .onDisappear {
            stopPreview()
        }
    }
    
    private func previewSound(_ sound: MeditationView.MeditationSound) {
        stopPreview()
        
        if let soundURL = Bundle.main.url(forResource: sound.rawValue, withExtension: "m4a") {
            do {
                previewPlayer = try AVAudioPlayer(contentsOf: soundURL)
                previewPlayer?.play()
                currentlyPreviewing = sound
                isAnimating = true
                
                // Stop after 30 seconds
                previewTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { _ in
                    stopPreview()
                }
            } catch {
                print("Failed to preview sound: \(error)")
            }
        }
    }
    
    private func stopPreview() {
        previewPlayer?.stop()
        previewPlayer = nil
        currentlyPreviewing = nil
        isAnimating = false
        previewTimer?.invalidate()
        previewTimer = nil
    }
}
