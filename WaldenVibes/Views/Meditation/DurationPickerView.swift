//  DurationPickerView.swift
import SwiftUI

struct DurationPickerView: View {
    @Binding var selectedDuration: TimeInterval
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
            .navigationTitle("duration.select")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func durationString(for seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        if minutes == 1 {
            return "1 \(NSLocalizedString("minute", comment: ""))"
        } else {
            return "\(minutes) \(NSLocalizedString("minutes", comment: ""))"
        }
    }
}
