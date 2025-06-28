//  EditEmotionView.swift
import SwiftUI
import AVFoundation

struct EditEmotionView: View {
    let emotion: Emotion
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    @State private var selectedType: EmotionType
    @State private var intensity: Double
    @State private var note: String
    @State private var includeLocation: Bool
    @State private var location: String
    @State private var previousIntensity: Double
    
    init(emotion: Emotion) {
        self.emotion = emotion
        _selectedType = State(initialValue: emotion.type)
        _intensity = State(initialValue: emotion.intensity)
        _note = State(initialValue: emotion.note)
        _includeLocation = State(initialValue: emotion.location != nil)
        _location = State(initialValue: emotion.location ?? "")
        _previousIntensity = State(initialValue: emotion.intensity)
    }
    
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
                            .onChange(of: intensity) { _, newValue in
                                // Progressive haptic feedback based on intensity
                                triggerProgressiveHaptic(for: newValue, previous: previousIntensity)
                                previousIntensity = newValue
                            }
                        
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
            .navigationTitle("Edit Emotion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save") {
                        updateEmotion()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    // MARK: - Haptic Feedback
    private func triggerProgressiveHaptic(for newValue: Double, previous: Double) {
        let difference = abs(newValue - previous)
        
        if difference >= 1 {
            // Determine intensity based on emotion intensity level
            let hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
            
            switch newValue {
            case 1...3:
                hapticStyle = .light
            case 4...6:
                hapticStyle = .medium
            case 7...10:
                hapticStyle = .heavy
            default:
                hapticStyle = .medium
            }
            
            let impactFeedback = UIImpactFeedbackGenerator(style: hapticStyle)
            impactFeedback.impactOccurred()
        }
    }
    
    private func updateEmotion() {
        // Create updated emotion
        let updatedEmotion = Emotion(
            id: emotion.id,
            type: selectedType,
            intensity: intensity,
            note: note,
            date: emotion.date, // Keep original date
            location: includeLocation && !location.isEmpty ? location : nil
        )
        
        // Update in data manager
        if let index = dataManager.emotions.firstIndex(where: { $0.id == emotion.id }) {
            dataManager.emotions[index] = updatedEmotion
            dataManager.saveEmotions()
        }
        
        // Strong haptic feedback for successful save
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
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
