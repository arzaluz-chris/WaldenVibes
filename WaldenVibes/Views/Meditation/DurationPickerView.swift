// WaldenVibes/Views/Meditation/DurationPickerView.swift
import SwiftUI

struct DurationPickerView: View {
    @Binding var selectedDuration: TimeInterval
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            NavigationView {
                ZStack {
                    // Animated glass background
                    AnimatedGlassBackground(color: Color("AccentColor"))

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
                            .listRowBackground(
                                Color.clear
                                    .background(.thinMaterial)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(LinearGradient(
                                                colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ), lineWidth: 0.5)
                                    )
                            )
                            .listRowSeparator(.hidden)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(InsetGroupedListStyle())
                    .listRowSpacing(12)
                    .navigationTitle("Select Duration")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                dismiss()
                            }
                        }
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
                        Button("Done") {
                            dismiss()
                        }
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
