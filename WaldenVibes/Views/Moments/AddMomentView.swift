//  AddMomentView.swift
import SwiftUI

struct AddMomentView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    @State private var description = ""
    @State private var selectedCategory: MomentCategory = .general
    @State private var duration = 30
    @State private var date = Date()
    
    let durationOptions = [15, 30, 45, 60, 90, 120, 180, 240, 300]
    
    var body: some View {
        NavigationView {
            Form {
                // Description
                Section {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                } header: {
                    Text("moment.description")
                } footer: {
                    Text("moment.description.footer")
                }
                
                // Category
                Section {
                    Picker("moment.category", selection: $selectedCategory) {
                        ForEach(MomentCategory.allCases, id: \.self) { category in
                            Label {
                                Text(category.localizedName)
                            } icon: {
                                Image(systemName: category.icon)
                                    .foregroundColor(category.color)
                            }
                            .tag(category)
                        }
                    }
                } header: {
                    Text("moment.category.section")
                }
                
                // Duration
                Section {
                    Picker("moment.duration", selection: $duration) {
                        ForEach(durationOptions, id: \.self) { minutes in
                            Text(formatDuration(minutes))
                                .tag(minutes)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 120)
                } header: {
                    Text("moment.duration.section")
                }
                
                // Date & Time
                Section {
                    DatePicker(
                        "moment.date",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                } header: {
                    Text("moment.date.section")
                }
            }
            .navigationTitle("moment.new")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save") {
                        saveMoment()
                    }
                    .fontWeight(.semibold)
                    .disabled(description.isEmpty)
                }
            }
        }
    }
    
    private func formatDuration(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            let mins = minutes % 60
            if mins == 0 {
                return "\(hours)h"
            } else {
                return "\(hours)h \(mins)min"
            }
        }
    }
    
    private func saveMoment() {
        let moment = Moment(
            description: description,
            category: selectedCategory,
            duration: duration,
            date: date
        )
        
        dataManager.addMoment(moment)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        dismiss()
    }
}
