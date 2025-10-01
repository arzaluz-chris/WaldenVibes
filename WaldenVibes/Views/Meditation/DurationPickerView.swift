// WaldenVibes/Views/Meditation/DurationPickerView.swift
import SwiftUI

struct DurationPickerView: View {
    @Binding var selectedDuration: TimeInterval
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            NavigationView {
                List {
                    ForEach(MeditationManager.durations, id: \.self) { duration in
                        HStack {
                            Text(durationString(for: duration))
                                .font(.body)
                            
                            Spacer()
                            
                            if selectedDuration == duration {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color("AccentColor"))
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color.clear.background(.thinMaterial))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedDuration = duration
                            dismiss()
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(AnimatedGlassBackground(color: Color("AccentColor")))
                .navigationTitle("Select Duration")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
            }
        } else {
            // MARK: - iOS 18 Design
            NavigationView {
                List {
                    ForEach(MeditationManager.durations, id: \.self) { duration in
                        HStack {
                            Text(durationString(for: duration))
                                .font(.body)
                            
                            Spacer()
                            
                            if selectedDuration == duration {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color("AccentColor"))
                                    .fontWeight(.semibold)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedDuration = duration
                            dismiss()
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Select Duration")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
            }
        }
    }
    
    private func durationString(for seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        if minutes == 1 {
            return String(localized: "\(minutes) minute", comment: "Duration in singular minute")
        } else {
            return String(localized: "\(minutes) minutes", comment: "Duration in plural minutes")
        }
    }
}
