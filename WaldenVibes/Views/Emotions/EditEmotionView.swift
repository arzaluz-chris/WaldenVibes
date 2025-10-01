// WaldenVibes/Views/Emotions/EditEmotionView.swift
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
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            NavigationView {
                ZStack {
                    AnimatedGlassBackground(color: selectedType.color).ignoresSafeArea()

                    Form {
                        // Emotion Selection
                        Section {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(EmotionType.allCases, id: \.self) { type in
                                        EmotionButton(
                                            type: type,
                                            isSelected: selectedType == type,
                                            action: { withAnimation(.spring()) { selectedType = type } }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                            }
                            .listRowBackground(Color.clear)
                        } header: {
                            Text("Select emotion", comment: "Section header for emotion selection")
                        }
                        
                        // Intensity Slider
                        Section {
                            intensitySliderContent
                        } header: {
                            Text("Emotion intensity", comment: "Section header for intensity slider")
                        }
                        .listRowBackground(formRowBackground)
                        
                        // Notes
                        Section {
                            notesEditorContent
                        } header: {
                            Text("Notes", comment: "Section header for notes field")
                        } footer: {
                            Text("Optional notes about how you're feeling", comment: "Footer text explaining the notes field")
                        }
                        .listRowBackground(formRowBackground)
                        
                        // Location
                        Section {
                            locationSelectorContent
                        } header: {
                            Text("Location", comment: "Section header for location field")
                        }
                        .listRowBackground(formRowBackground)
                    }
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Edit Emotion")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { navigationToolbar }
                }
                .onTapGesture { hideKeyboard() }
                .onAppear { previousIntensity = intensity }

            }
        } else {
            // MARK: - iOS 18 Design
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
                        Text("Select emotion", comment: "Section header for emotion selection")
                    }
                    
                    // Intensity Slider
                    Section {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Intensity", comment: "Label for emotion intensity")
                                Spacer()
                                Text("\(Int(intensity))")
                                    .fontWeight(.semibold)
                                    .foregroundColor(selectedType.color)
                            }
                            
                            Slider(value: $intensity, in: 1...10, step: 1)
                                .accentColor(selectedType.color)
                                .onChange(of: intensity) { _, newValue in
                                    triggerProgressiveHaptic(for: newValue, previous: previousIntensity)
                                    previousIntensity = newValue
                                }
                            
                            IntensityView(intensity: intensity, color: selectedType.color)
                                .frame(maxWidth: .infinity)
                        }
                    } header: {
                        Text("Emotion intensity", comment: "Section header for intensity slider")
                    }
                    
                    // Notes
                    Section {
                        TextEditor(text: $note)
                            .frame(minHeight: 100)
                    } header: {
                        Text("Notes", comment: "Section header for notes field")
                    } footer: {
                        Text("Optional notes about how you're feeling", comment: "Footer text explaining the notes field")
                    }
                    
                    // Location
                    Section {
                        Toggle("Include location", isOn: $includeLocation)
                        
                        if includeLocation {
                            TextField("Location", text: $location, prompt: Text("Where are you?"))
                        }
                    } header: {
                        Text("Location", comment: "Section header for location field")
                    }
                }
                .navigationTitle("Edit Emotion")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                    ToolbarItem(placement: .navigationBarTrailing) { Button("Save") { updateEmotion() }.fontWeight(.semibold) }
                }
                .onTapGesture { hideKeyboard() }
            }
        }
    }

    // MARK: - iOS 26 View Components
    
    @available(iOS 26.0, *)
    private var formRowBackground: some View {
        Color.clear
            .background(.thinMaterial)
            .cornerRadius(12)
    }

    @available(iOS 26.0, *)
    private var intensitySliderContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Intensity", comment: "Label for emotion intensity")
                Spacer()
                Text("\(Int(intensity))").fontWeight(.semibold).foregroundColor(selectedType.color)
            }
            Slider(value: $intensity, in: 1...10, step: 1)
                .accentColor(selectedType.color)
                .onChange(of: intensity) { _, newValue in
                    triggerProgressiveHaptic(for: newValue, previous: previousIntensity)
                    previousIntensity = newValue
                }
            IntensityView(intensity: intensity, color: selectedType.color).frame(maxWidth: .infinity)
        }
        .padding()
    }

    @available(iOS 26.0, *)
    private var notesEditorContent: some View {
        TextEditor(text: $note)
            .frame(minHeight: 100)
            .background(Color.clear)
            .padding(4)
    }

    @available(iOS 26.0, *)
    private var locationSelectorContent: some View {
        VStack {
            Toggle("Include location", isOn: $includeLocation)
                .tint(Color("AccentColor"))
            
            if includeLocation {
                TextField("Location", text: $location, prompt: Text("Where are you?"))
                    .textFieldStyle(.plain)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .padding(.top, 4)
            }
        }
        .padding()
    }
    
    @ToolbarContentBuilder
    private var navigationToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
        ToolbarItem(placement: .navigationBarTrailing) { Button("Save") { updateEmotion() }.fontWeight(.semibold) }
    }
    
    // MARK: - Helper Functions
    private func triggerProgressiveHaptic(for newValue: Double, previous: Double) {
        let difference = abs(newValue - previous)
        if difference >= 1 {
            let hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
            switch newValue {
            case 1...3: hapticStyle = .light
            case 4...6: hapticStyle = .medium
            case 7...10: hapticStyle = .heavy
            default: hapticStyle = .medium
            }
            UIImpactFeedbackGenerator(style: hapticStyle).impactOccurred()
        }
    }
    
    private func updateEmotion() {
        let updatedEmotion = Emotion(
            id: emotion.id,
            type: selectedType,
            intensity: intensity,
            note: note,
            date: emotion.date,
            location: includeLocation && !location.isEmpty ? location : nil
        )
        
        if let index = dataManager.emotions.firstIndex(where: { $0.id == emotion.id }) {
            dataManager.emotions[index] = updatedEmotion
            dataManager.saveEmotions()
        }
        
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        
        if let soundURL = Bundle.main.url(forResource: "EmotionRecorded", withExtension: "mp3") {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
        
        dismiss()
    }
}
