// WaldenVibes/Views/Stress/AddStressView.swift
import SwiftUI

struct AddStressView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    @State private var stressInputMethod: StressInputMethod = .manual
    @State private var stressLevel: Double = 5
    @State private var selectedTriggers: Set<StressTrigger> = []
    @State private var note = ""
    @State private var previousStressLevel: Double = 5
    @State private var showingStressTest = false
    
    enum StressInputMethod: String, CaseIterable {
        case manual = "manual"
        case test = "test"
        
        var displayName: LocalizedStringKey {
            switch self {
            case .manual: return LocalizedStringKey("Manual Entry")
            case .test: return LocalizedStringKey("Quick Assessment")
            }
        }
        
        var description: LocalizedStringKey {
            switch self {
            case .manual: return LocalizedStringKey("Set your stress level directly")
            case .test: return LocalizedStringKey("Take a quick test to determine your stress level")
            }
        }
        
        var icon: String {
            switch self {
            case .manual: return "slider.horizontal.3"
            case .test: return "doc.text.magnifyingglass"
            }
        }
    }
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            NavigationView {
                ZStack {
                    AnimatedGlassBackground(color: colorForLevel(stressLevel)).ignoresSafeArea()
                    
                    Form {
                        inputMethodSection
                        
                        if stressInputMethod == .manual {
                            manualStressLevelSection
                        }
                        
                        triggersSection
                        notesSection
                    }
                    .scrollContentBackground(.hidden)
                    .navigationTitle("New Stress Record")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { navigationToolbar }
                }
                .onAppear { previousStressLevel = stressLevel }
                .sheet(isPresented: $showingStressTest) { StressTestView() }
            }
            
        } else {
            // MARK: - iOS 18 Design
            NavigationView {
                Form {
                    Section {
                        ForEach(StressInputMethod.allCases, id: \.self) { method in
                            Button(action: {
                                if method == .test { showingStressTest = true }
                                else { stressInputMethod = method }
                            }) {
                                HStack(spacing: 16) {
                                    Image(systemName: method.icon).font(.title2).foregroundColor(stressInputMethod == method ? Color("AccentColor") : .secondary).frame(width: 30)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(method.displayName).font(.headline).foregroundColor(.primary)
                                        Text(method.description).font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.leading)
                                    }
                                    Spacer()
                                    if stressInputMethod == method { Image(systemName: "checkmark.circle.fill").font(.title2).foregroundColor(Color("AccentColor")) }
                                    if method == .test { Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary) }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    } header: { Text("How would you like to assess your stress?", comment: "Section header for stress input method") }
                    footer: { Text("The quick assessment provides a more accurate measurement based on multiple factors", comment: "Footer explaining stress test benefits") }
                    
                    if stressInputMethod == .manual {
                        Section {
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Stress Level", comment: "Label for stress level slider"); Spacer()
                                    Text("\(Int(stressLevel))/10").font(.title2).fontWeight(.semibold).foregroundColor(colorForLevel(stressLevel))
                                }
                                Slider(value: $stressLevel, in: 0...10, step: 1).accentColor(colorForLevel(stressLevel))
                                    .onChange(of: stressLevel) { _, newValue in
                                        triggerProgressiveStressHaptic(for: newValue, previous: previousStressLevel)
                                        previousStressLevel = newValue
                                    }
                                HStack {
                                    Text(emojiForLevel(stressLevel)).font(.largeTitle)
                                    Text(descriptionForLevel(stressLevel)).font(.headline).foregroundColor(colorForLevel(stressLevel))
                                }.frame(maxWidth: .infinity)
                            }
                        } header: { Text("How stressed are you feeling?", comment: "Section header for stress level") }
                    }
                    
                    Section {
                        ForEach(StressTrigger.allCases, id: \.self) { trigger in
                            HStack {
                                Image(systemName: trigger.icon).foregroundColor(selectedTriggers.contains(trigger) ? Color("AccentColor") : .secondary).frame(width: 30)
                                Text(trigger.localizedName); Spacer()
                                if selectedTriggers.contains(trigger) { Image(systemName: "checkmark").foregroundColor(Color("AccentColor")).fontWeight(.semibold) }
                            }.contentShape(Rectangle()).onTapGesture {
                                if selectedTriggers.contains(trigger) { selectedTriggers.remove(trigger) }
                                else { selectedTriggers.insert(trigger) }
                            }
                        }
                    } header: { Text("Stress Triggers", comment: "Section header for stress triggers") }
                    footer: { Text("Select factors contributing to your stress", comment: "Helper text for stress triggers") }
                    
                    Section {
                        TextEditor(text: $note).frame(minHeight: 100)
                            .toolbar { ToolbarItemGroup(placement: .keyboard) { Spacer(); Button("Done") { hideKeyboard() } } }
                    } header: { Text("Notes", comment: "Section header for notes field") }
                    footer: { Text("Add details about what's causing your stress", comment: "Helper text for stress notes") }
                }
                .navigationTitle("New Stress Record").navigationBarTitleDisplayMode(.inline).navigationBarBackground()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                    ToolbarItem(placement: .navigationBarTrailing) { Button("Save") { saveStress() }.fontWeight(.semibold).disabled(stressInputMethod == .test) }
                }
            }
            .onAppear { previousStressLevel = stressLevel }
            .sheet(isPresented: $showingStressTest) { StressTestView() }
        }
    }
    
    // MARK: - iOS 26 View Components
    
    @available(iOS 26.0, *)
    private var formRowBackground: some View {
        Color.clear.background(.thinMaterial).cornerRadius(12)
    }

    @available(iOS 26.0, *)
    private var inputMethodSection: some View {
        Section {
            ForEach(StressInputMethod.allCases, id: \.self) { method in
                Button(action: {
                    if method == .test { showingStressTest = true }
                    else { stressInputMethod = method }
                }) {
                    HStack(spacing: 16) {
                        Image(systemName: method.icon).font(.title2).foregroundColor(stressInputMethod == method ? Color("AccentColor") : .secondary).frame(width: 30)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(method.displayName).font(.headline).foregroundColor(.primary)
                            Text(method.description).font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.leading)
                        }
                        Spacer()
                        if stressInputMethod == method { Image(systemName: "checkmark.circle.fill").font(.title2).foregroundColor(Color("AccentColor")) }
                        if method == .test { Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary) }
                    }
                }.buttonStyle(PlainButtonStyle())
            }
        } header: { Text("How would you like to assess your stress?", comment: "Section header for stress input method") }
        footer: { Text("The quick assessment provides a more accurate measurement based on multiple factors", comment: "Footer explaining stress test benefits") }
        .listRowBackground(formRowBackground)
    }

    @available(iOS 26.0, *)
    private var manualStressLevelSection: some View {
        Section {
            VStack(spacing: 20) {
                HStack {
                    Text("Stress Level", comment: "Label for stress level slider"); Spacer()
                    Text("\(Int(stressLevel))/10").font(.title2).fontWeight(.semibold).foregroundColor(colorForLevel(stressLevel))
                }
                Slider(value: $stressLevel, in: 0...10, step: 1).accentColor(colorForLevel(stressLevel))
                    .onChange(of: stressLevel) { _, newValue in
                        triggerProgressiveStressHaptic(for: newValue, previous: previousStressLevel)
                        previousStressLevel = newValue
                    }
                HStack {
                    Text(emojiForLevel(stressLevel)).font(.largeTitle)
                    Text(descriptionForLevel(stressLevel)).font(.headline).foregroundColor(colorForLevel(stressLevel))
                }.frame(maxWidth: .infinity)
            }.padding()
        } header: { Text("How stressed are you feeling?", comment: "Section header for stress level") }
        .listRowBackground(formRowBackground)
    }

    @available(iOS 26.0, *)
    private var triggersSection: some View {
        Section {
            ForEach(StressTrigger.allCases, id: \.self) { trigger in
                HStack {
                    Image(systemName: trigger.icon).foregroundColor(selectedTriggers.contains(trigger) ? Color("AccentColor") : .secondary).frame(width: 30)
                    Text(trigger.localizedName); Spacer()
                    if selectedTriggers.contains(trigger) { Image(systemName: "checkmark").foregroundColor(Color("AccentColor")).fontWeight(.semibold) }
                }.contentShape(Rectangle()).onTapGesture {
                    if selectedTriggers.contains(trigger) { selectedTriggers.remove(trigger) } else { selectedTriggers.insert(trigger) }
                }
            }
        } header: { Text("Stress Triggers", comment: "Section header for stress triggers") }
        footer: { Text("Select factors contributing to your stress", comment: "Helper text for stress triggers") }
        .listRowBackground(formRowBackground)
    }
    
    @available(iOS 26.0, *)
    private var notesSection: some View {
        Section {
            TextEditor(text: $note).frame(minHeight: 100).background(Color.clear)
                .toolbar { ToolbarItemGroup(placement: .keyboard) { Spacer(); Button("Done") { hideKeyboard() } } }
        } header: { Text("Notes", comment: "Section header for notes field") }
        footer: { Text("Add details about what's causing your stress", comment: "Helper text for stress notes") }
        .listRowBackground(formRowBackground)
    }
    
    @ToolbarContentBuilder
    private var navigationToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
        ToolbarItem(placement: .navigationBarTrailing) { Button("Save") { saveStress() }.fontWeight(.semibold).disabled(stressInputMethod == .test) }
    }
    
    // MARK: - Helper Functions
    private func triggerProgressiveStressHaptic(for newValue: Double, previous: Double) {
        let difference = abs(newValue - previous)
        if difference >= 1 {
            let hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
            switch newValue {
            case 0...2: hapticStyle = .light
            case 3...5: hapticStyle = .medium
            case 6...7: hapticStyle = .heavy
            case 8...10:
                let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedback.impactOccurred()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { impactFeedback.impactOccurred() }
                return
            default: hapticStyle = .medium
            }
            UIImpactFeedbackGenerator(style: hapticStyle).impactOccurred()
        }
    }
    
    private func colorForLevel(_ level: Double) -> Color {
        switch level {
        case 0..<3: return Color("StressLow")
        case 3..<5: return Color("StressModerate")
        case 5..<7: return Color("StressHigh")
        case 7...10: return Color("StressVeryHigh")
        default: return .gray
        }
    }
    
    private func emojiForLevel(_ level: Double) -> String {
        switch level {
        case 0..<3: return "😌"
        case 3..<5: return "😐"
        case 5..<7: return "😟"
        case 7...10: return "😰"
        default: return "🤔"
        }
    }
    
    private func descriptionForLevel(_ level: Double) -> LocalizedStringKey {
        switch level {
        case 0..<3: return LocalizedStringKey("Low")
        case 3..<5: return LocalizedStringKey("Moderate")
        case 5..<7: return LocalizedStringKey("High")
        case 7...10: return LocalizedStringKey("Very High")
        default: return LocalizedStringKey("Unknown")
        }
    }
    
    private func saveStress() {
        let stress = Stress(level: stressLevel, triggers: Array(selectedTriggers), note: note)
        dataManager.addStressRecord(stress)
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        dismiss()
    }
}
