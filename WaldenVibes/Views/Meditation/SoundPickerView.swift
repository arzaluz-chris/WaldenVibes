// SoundPickerView.swift
import SwiftUI
import AVFoundation

struct SoundPickerView: View {
    @Binding var selectedSound: MeditationView.MeditationSound?
    @Environment(\.dismiss) var dismiss
    @State private var previewPlayer: AVAudioPlayer?
    @State private var currentlyPreviewing: MeditationView.MeditationSound?
    
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
                        
                        // Preview button
                        if sound != .none {
                            Button(action: {
                                if currentlyPreviewing == sound {
                                    stopPreview()
                                } else {
                                    previewSound(sound)
                                }
                            }) {
                                Image(systemName: currentlyPreviewing == sound ? "stop.circle.fill" : "play.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
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
                
                // Stop after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    if currentlyPreviewing == sound {
                        stopPreview()
                    }
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
    }
}
