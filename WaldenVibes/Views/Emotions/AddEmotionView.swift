//  AddEmotionView.swift
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
        NavigationView {
            ZStack {
                // Invisible background to detect taps
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }
                
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
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        hideKeyboard()
                                    }
                                }
                            }
                    } header: {
                        Text("notes.section")
                    } footer: {
                        Text("notes.footer")
                    }
                    
                    // Location
                    Section {
                        ForEach(LocationOption.allCases, id: \.self) { location in
                            HStack {
                                Image(systemName: location.icon)
                                    .foregroundColor(selectedLocation == location ? Color("AccentColor") : .secondary)
                                    .frame(width: 30)
                                
                                Text(location.rawValue)
                                
                                Spacer()
                                
                                if selectedLocation == location {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color("AccentColor"))
                                        .fontWeight(.semibold)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedLocation = location
                            }
                        }
                        
                        if selectedLocation == .other {
                            TextField("Specify location", text: $customLocation)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    } header: {
                        Text("location.section")
                    }
                }
            }
            .navigationTitle("emotion.new")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackground()
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
        .onAppear {
            previousIntensity = intensity
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
    
    private func saveEmotion() {
        let locationString: String? = {
            if selectedLocation == .other && !customLocation.isEmpty {
                return customLocation
            } else if selectedLocation != .other {
                return selectedLocation.rawValue
            }
            return nil
        }()
        
        let emotion = Emotion(
            type: selectedType,
            intensity: intensity,
            note: note,
            location: locationString
        )
        
        dataManager.addEmotion(emotion)
        
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

// Navigation bar background extension
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
