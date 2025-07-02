// WaldenVibes/Views/Moments/Components/EditMomentView.swift
import SwiftUI

struct EditMomentView: View {
    let moment: Moment
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    @State private var description: String
    @State private var selectedCategory: MomentCategory
    @State private var duration: Int
    @State private var date: Date
    
    let durationOptions = [15, 30, 45, 60, 90, 120, 180, 240, 300]
    
    init(moment: Moment) {
        self.moment = moment
        _description = State(initialValue: moment.description)
        _selectedCategory = State(initialValue: moment.category)
        _duration = State(initialValue: moment.duration)
        _date = State(initialValue: moment.date)
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
                    // Description
                    Section {
                        TextEditor(text: $description)
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
                        Text("Description", comment: "Section header for moment description")
                    } footer: {
                        Text("Describe what made this moment special", comment: "Helper text for moment description field")
                    }
                    
                    // Category
                    Section {
                        Picker("Category", selection: $selectedCategory) {
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
                        Text("Category", comment: "Section header for moment category")
                    }
                    
                    // Duration
                    Section {
                        Picker("Duration", selection: $duration) {
                            ForEach(durationOptions, id: \.self) { minutes in
                                Text(formatDuration(minutes))
                                    .tag(minutes)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 120)
                    } header: {
                        Text("Duration", comment: "Section header for moment duration")
                    }
                    
                    // Date & Time
                    Section {
                        DatePicker(
                            "Date & Time",
                            selection: $date,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    } header: {
                        Text("When", comment: "Section header for moment date and time")
                    }
                }
            }
            .navigationTitle("Edit Moment")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackground()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        updateMoment()
                    }
                    .fontWeight(.semibold)
                    .disabled(description.isEmpty)
                }
            }
        }
    }
    
    private func formatDuration(_ minutes: Int) -> String {
        if minutes < 60 {
            return String(localized: "\(minutes) min", comment: "Duration in minutes")
        } else {
            let hours = minutes / 60
            let mins = minutes % 60
            if mins == 0 {
                return String(localized: "\(hours)h", comment: "Duration in hours")
            } else {
                return String(localized: "\(hours)h \(mins)min", comment: "Duration in hours and minutes")
            }
        }
    }
    
    private func updateMoment() {
        // Create updated moment
        let updatedMoment = Moment(
            id: moment.id,
            description: description,
            category: selectedCategory,
            duration: duration,
            date: date
        )
        
        // Update in data manager
        if let index = dataManager.moments.firstIndex(where: { $0.id == moment.id }) {
            dataManager.moments[index] = updatedMoment
            dataManager.saveMoments()
        }
        
        // Strong haptic feedback for successful save
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        dismiss()
    }
}
