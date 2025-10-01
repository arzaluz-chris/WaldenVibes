// WaldenVibes/Views/Emotions/AddEmotionView.swift
import SwiftUI
import AVFoundation

struct AddEmotionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    @State private var selectedType: EmotionType = .happy
    @State private var intensity: Double = 5
    @State private var note = ""
    @State private var selectedLocation: LocationOption = .other
    @State private var customLocation = ""
    @State private var previousIntensity: Double = 5
    
    // Location options
    enum LocationOption: String, CaseIterable {
        case home = "Home"
        case work = "Work"
        case school = "School"
        case outdoors = "Outdoors"
        case transit = "Transit"
        case other = "Other"
        
        var localizedName: String {
            switch self {
            case .home: return String(localized: "Home", comment: "Location option for home")
            case .work: return String(localized: "Work", comment: "Location option for work")
            case .school: return String(localized: "School", comment: "Location option for school")
            case .outdoors: return String(localized: "Outdoors", comment: "Location option for outdoor activities")
            case .transit: return String(localized: "Transit", comment: "Location option for commuting/transit")
            case .other: return String(localized: "Other", comment: "Location option for other places")
            }
        }
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .work: return "briefcase.fill"
            case .school: return "graduationcap.fill"
            case .outdoors: return "leaf.fill"
            case .transit: return "car.fill"
            case .other: return "mappin.circle.fill"
            }
        }
    }
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            NavigationView {
                ZStack {
                    // Animated glass background for the entire view
                    AnimatedGlassBackground(color: selectedType.color)
                        .ignoresSafeArea()

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
                            Text("Location", comment: "Section header for location selection")
                        }
                        .listRowBackground(formRowBackground)
                    }
                    .scrollContentBackground(.hidden) // Make form background transparent
                    .navigationTitle("New Emotion")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { navigationToolbar }
                }
                .onAppear { previousIntensity = intensity }
            }
        } else {
            // MARK: - iOS 18 Design
            NavigationView {
                ZStack {
                    Color.clear.contentShape(Rectangle()).onTapGesture { hideKeyboard() }
                    Form {
                        Section {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(EmotionType.allCases, id: \.self) { type in
                                        EmotionButton(type: type, isSelected: selectedType == type) {
                                            withAnimation(.spring()) { selectedType = type }
                                        }
                                    }
                                }
                                .padding(.vertical, 10)
                            }
                        } header: { Text("Select emotion", comment: "Section header for emotion selection") }
                        
                        Section {
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
                        } header: { Text("Emotion intensity", comment: "Section header for intensity slider") }
                        
                        Section {
                            TextEditor(text: $note).frame(minHeight: 100)
                                .toolbar { ToolbarItemGroup(placement: .keyboard) { Spacer(); Button("Done") { hideKeyboard() } } }
                        } header: { Text("Notes", comment: "Section header for notes field") }
                        footer: { Text("Optional notes about how you're feeling", comment: "Footer text explaining the notes field") }
                        
                        Section {
                            ForEach(LocationOption.allCases, id: \.self) { location in
                                HStack {
                                    Image(systemName: location.icon).foregroundColor(selectedLocation == location ? Color("AccentColor") : .secondary).frame(width: 30)
                                    Text(location.localizedName)
                                    Spacer()
                                    if selectedLocation == location {
                                        Image(systemName: "checkmark").foregroundColor(Color("AccentColor")).fontWeight(.semibold)
                                    }
                                }
                                .contentShape(Rectangle()).onTapGesture { selectedLocation = location }
                            }
                            if selectedLocation == .other {
                                TextField("Specify location", text: $customLocation, prompt: Text("Where are you?")).textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        } header: { Text("Location", comment: "Section header for location selection") }
                    }
                }
                .navigationTitle("New Emotion")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackground()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                    ToolbarItem(placement: .navigationBarTrailing) { Button("Save") { saveEmotion() }.fontWeight(.semibold) }
                }
            }
            .onAppear { previousIntensity = intensity }
        }
    }
    
    // MARK: - iOS 26 View Components
    
    @available(iOS 26.0, *)
    private var formRowBackground: some View {
        Color.clear
            .background(.thinMaterial)
            .cornerRadius(12) // Ensure corner radius is applied to the material
    }

    @available(iOS 26.0, *)
    private var intensitySliderContent: some View {
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
        .padding()
    }

    @available(iOS 26.0, *)
    private var notesEditorContent: some View {
        TextEditor(text: $note)
            .frame(minHeight: 100)
            .background(Color.clear) // Make TextEditor transparent
            .padding(4)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { hideKeyboard() }
                }
            }
    }
    
    @available(iOS 26.0, *)
    private var locationSelectorContent: some View {
        VStack {
            ForEach(LocationOption.allCases, id: \.self) { location in
                HStack {
                    Image(systemName: location.icon)
                        .foregroundColor(selectedLocation == location ? Color("AccentColor") : .secondary)
                        .frame(width: 30)
                    Text(location.localizedName)
                    Spacer()
                    if selectedLocation == location {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color("AccentColor"))
                            .fontWeight(.semibold)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { selectedLocation = location }
                .padding(.vertical, 4)
            }
            
            if selectedLocation == .other {
                TextField("Specify location", text: $customLocation, prompt: Text("Where are you?"))
                    .textFieldStyle(.plain)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
    
    @ToolbarContentBuilder
    private var navigationToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
        ToolbarItem(placement: .navigationBarTrailing) { Button("Save") { saveEmotion() }.fontWeight(.semibold) }
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
    
    private func saveEmotion() {
        let locationString: String? = {
            if selectedLocation == .other && !customLocation.isEmpty { return customLocation }
            else if selectedLocation != .other { return selectedLocation.localizedName }
            return nil
        }()
        
        let emotion = Emotion(type: selectedType, intensity: intensity, note: note, location: locationString)
        dataManager.addEmotion(emotion)
        
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        
        if let soundURL = Bundle.main.url(forResource: "EmotionRecorded", withExtension: "mp3") {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
        
        dismiss()
    }
}

// MARK: - Navigation Bar Background Modifier (for iOS 18)
extension View {
    func navigationBarBackground() -> some View {
        self.modifier(NavigationBarBackgroundModifier())
    }
}

struct NavigationBarBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(UIColor.systemBackground), for: .navigationBar)
    }
}
