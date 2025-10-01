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
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            NavigationView {
                List {
                    ForEach(MeditationView.MeditationSound.allCases, id: \.self) { sound in
                        soundRow(sound)
                            .listRowBackground(Color.clear.background(.thinMaterial))
                    }
                }
                .scrollContentBackground(.hidden)
                .background(AnimatedGlassBackground(color: Color("AccentColor")))
                .navigationTitle("Select Sound")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { stopPreview(); dismiss() }
                    }
                }
            }
            .onDisappear(perform: stopPreview)
            
        } else {
            // MARK: - iOS 18 Design
            NavigationView {
                List {
                    ForEach(MeditationView.MeditationSound.allCases, id: \.self) { sound in
                        HStack {
                            Image(systemName: sound.icon).font(.title2).foregroundColor(Color("AccentColor")).frame(width: 40)
                            VStack(alignment: .leading) { Text(sound.displayName).font(.body) }
                            Spacer()
                            if sound != .none {
                                Button(action: {
                                    if currentlyPreviewing == sound { stopPreview() } else { previewSound(sound) }
                                }) {
                                    ZStack {
                                        if currentlyPreviewing == sound {
                                            Circle().stroke(Color.blue.opacity(0.3), lineWidth: 2).frame(width: 35, height: 35)
                                                .scaleEffect(isAnimating ? 1.2 : 1.0).opacity(isAnimating ? 0 : 1)
                                                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: isAnimating)
                                        }
                                        Image(systemName: currentlyPreviewing == sound ? "stop.circle.fill" : "play.circle.fill")
                                            .font(.title2).foregroundColor(.blue)
                                    }
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            if selectedSound == sound {
                                Image(systemName: "checkmark").foregroundColor(Color("AccentColor")).fontWeight(.semibold)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { selectedSound = sound; stopPreview(); dismiss() }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Select Sound")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { stopPreview(); dismiss() }
                    }
                }
            }
            .onDisappear(perform: stopPreview)
        }
    }
    
    @available(iOS 26.0, *)
    private func soundRow(_ sound: MeditationView.MeditationSound) -> some View {
        HStack {
            Image(systemName: sound.icon).font(.title2).foregroundColor(Color("AccentColor")).frame(width: 40)
            Text(sound.displayName).font(.body)
            Spacer()
            
            if sound != .none {
                Button(action: {
                    if currentlyPreviewing == sound { stopPreview() } else { previewSound(sound) }
                }) {
                    ZStack {
                        if currentlyPreviewing == sound {
                            Circle().stroke(Color.blue.opacity(0.5), lineWidth: 2).frame(width: 35, height: 35)
                                .scaleEffect(isAnimating ? 1.3 : 1.0).opacity(isAnimating ? 0 : 1)
                                .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: isAnimating)
                        }
                        Image(systemName: currentlyPreviewing == sound ? "stop.circle.fill" : "play.circle.fill")
                            .font(.title2).foregroundColor(.blue)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            
            if selectedSound == sound {
                Image(systemName: "checkmark").foregroundColor(Color("AccentColor")).fontWeight(.semibold)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture { selectedSound = sound; stopPreview(); dismiss() }
    }
    
    private func previewSound(_ sound: MeditationView.MeditationSound) {
        stopPreview()
        if let soundURL = Bundle.main.url(forResource: sound.rawValue, withExtension: "m4a") {
            do {
                previewPlayer = try AVAudioPlayer(contentsOf: soundURL)
                previewPlayer?.play()
                currentlyPreviewing = sound
                isAnimating = true
                previewTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { _ in stopPreview() }
            } catch { print("Failed to preview sound: \(error)") }
        }
    }
    
    private func stopPreview() {
        previewPlayer?.stop(); previewPlayer = nil
        currentlyPreviewing = nil; isAnimating = false
        previewTimer?.invalidate(); previewTimer = nil
    }
}
