//  AddStressView.swift
import SwiftUI

struct AddStressView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    @State private var stressLevel: Double = 5
    @State private var selectedTriggers: Set<StressTrigger> = []
    @State private var note = ""
    
    var body: some View {
        NavigationView {
            Form {
                // Stress Level
                Section {
                    VStack(spacing: 20) {
                        // Level indicator
                        HStack {
                            Text("stress.level")
                            Spacer()
                            Text("\(Int(stressLevel))/10")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(colorForLevel(stressLevel))
                        }
                        
                        // Slider
                        Slider(value: $stressLevel, in: 0...10, step: 1)
                            .accentColor(colorForLevel(stressLevel))
                        
                        // Visual indicator
                        HStack {
                            Text(emojiForLevel(stressLevel))
                                .font(.largeTitle)
                            
                            Text(descriptionForLevel(stressLevel))
                                .font(.headline)
                                .foregroundColor(colorForLevel(stressLevel))
                        }
                        .frame(maxWidth: .infinity)
                    }
                } header: {
                    Text("stress.level.section")
                }
                
                // Triggers
                Section {
                    ForEach(StressTrigger.allCases, id: \.self) { trigger in
                        HStack {
                            Image(systemName: trigger.icon)
                                .foregroundColor(selectedTriggers.contains(trigger) ? Color("AccentColor") : .secondary)
                                .frame(width: 30)
                            
                            Text(trigger.localizedName)
                            
                            Spacer()
                            
                            if selectedTriggers.contains(trigger) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color("AccentColor"))
                                    .fontWeight(.semibold)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedTriggers.contains(trigger) {
                                selectedTriggers.remove(trigger)
                            } else {
                                selectedTriggers.insert(trigger)
                            }
                        }
                    }
                } header: {
                    Text("stress.triggers.section")
                } footer: {
                    Text("stress.triggers.footer")
                }
                
                // Notes
                Section {
                    TextEditor(text: $note)
                        .frame(minHeight: 100)
                } header: {
                    Text("notes.section")
                } footer: {
                    Text("stress.notes.footer")
                }
            }
            .navigationTitle("stress.new")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save") {
                        saveStress()
                    }
                    .fontWeight(.semibold)
                }
            }
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
        case 0..<3: return "stress.level.low"
        case 3..<5: return "stress.level.moderate"
        case 5..<7: return "stress.level.high"
        case 7...10: return "stress.level.veryhigh"
        default: return "stress.level.unknown"
        }
    }
    
    private func saveStress() {
        let stress = Stress(
            level: stressLevel,
            triggers: Array(selectedTriggers),
            note: note
        )
        
        dataManager.addStressRecord(stress)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        dismiss()
    }
}
