// AddEmotionView.swift - Updated with sound
import SwiftUI
import AVFoundation

struct AddEmotionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    @State private var selectedType: EmotionType = .happy
    @State private var intensity: Double = 5
    @State private var note = ""
    @State private var includeLocation = false
    @State private var location = ""
    
    var body: some View {
        NavigationView {
            Form {
                // Emotion Selection
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(EmotionType.allCases, id: \.self) { type in
                                EmotionButton(
                                    type: type,
                                    isSelected: selectedType == type,
                                    action: {
                                        withAnimation(.spring()) {
                                            selectedType = type
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.vertical, 10)
                    }
                } header: {
                    Text("emotion.select")
                }
                
                // Intensity Slider
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("intensity.label")
                            Spacer()
                            Text("\(Int(intensity))")
                                .fontWeight(.semibold)
                                .foregroundColor(selectedType.color)
                        }
                        
                        Slider(value: $intensity, in: 1...10, step: 1)
                            .accentColor(selectedType.color)
                        
                        IntensityView(intensity: intensity, color: selectedType.color)
                            .frame(maxWidth: .infinity)
                    }
                } header: {
                    Text("intensity.section")
                }
                
                // Notes
                Section {
                    TextEditor(text: $note)
                        .frame(minHeight: 100)
                } header: {
                    Text("notes.section")
                } footer: {
                    Text("notes.footer")
                }
                
                // Location
                Section {
                    Toggle("location.include", isOn: $includeLocation)
                    
                    if includeLocation {
                        TextField("location.placeholder", text: $location)
                    }
                } header: {
                    Text("location.section")
                }
            }
            .navigationTitle("emotion.new")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save") {
                        saveEmotion()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func saveEmotion() {
        let emotion = Emotion(
            type: selectedType,
            intensity: intensity,
            note: note,
            location: includeLocation && !location.isEmpty ? location : nil
        )
        
        dataManager.addEmotion(emotion)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Play custom sound
        if let soundURL = Bundle.main.url(forResource: "EmotionRecorded", withExtension: "mp3") {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
        
        dismiss()
    }
}
