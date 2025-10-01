// WaldenVibes/Views/Moments/MomentDetailView.swift
import SwiftUI

struct MomentDetailView: View {
    let moment: Moment
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var showingDeleteAlert = false
    @State private var showingEditView = false
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            NavigationView {
                ZStack {
                    // Animated glass background
                    AnimatedGlassBackground(color: moment.category.color)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Header with category
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(moment.category.color.opacity(0.2))
                                        .frame(width: 100, height: 100)
                                        .shadow(color: moment.category.color.opacity(0.3), radius: 20, y: 10)

                                    Image(systemName: moment.category.icon)
                                        .font(.system(size: 50))
                                        .foregroundColor(moment.category.color)
                                }

                                Text(moment.category.localizedName)
                                    .font(.title2)
                                    .fontWeight(.semibold)

                                Text(moment.date.formatted(date: .complete, time: .shortened))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)

                            // Details
                            VStack(alignment: .leading, spacing: 20) {
                                // Description
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("Description", systemImage: "text.alignleft")
                                        .font(.headline)

                                    Text(moment.description)
                                        .font(.body)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(.regularMaterial)
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(LinearGradient(
                                                    colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ), lineWidth: 1)
                                        )
                                }

                                Divider()

                                // Duration
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("Duration", systemImage: "clock.fill")
                                        .font(.headline)

                                    HStack {
                                        Image(systemName: "hourglass")
                                            .foregroundColor(moment.category.color)
                                        Text(moment.formattedDuration)
                                            .font(.title3)
                                            .fontWeight(.medium)
                                    }
                                }

                                Divider()

                                // Time of day
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("Time", systemImage: "calendar.circle")
                                        .font(.headline)

                                    HStack {
                                        Text(moment.date, style: .time)
                                            .font(.body)
                                        Text("•")
                                            .foregroundColor(.secondary)
                                        Text(timeOfDayDescription(for: moment.date))
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Done") {
                            dismiss()
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 16) {
                            Button(action: { showingEditView = true }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(Color("AccentColor"))
                            }

                            Button(action: { showingDeleteAlert = true }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .alert("Delete Moment?", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        dataManager.deleteMoment(moment)
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to delete this special moment?")
                }
            }
            .sheet(isPresented: $showingEditView) {
                EditMomentView(moment: moment)
            }
        } else {
            // MARK: - iOS 18 Design
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header with category
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(moment.category.color.opacity(0.2))
                                    .frame(width: 100, height: 100)

                                Image(systemName: moment.category.icon)
                                    .font(.system(size: 50))
                                    .foregroundColor(moment.category.color)
                            }

                            Text(moment.category.localizedName)
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text(moment.date.formatted(date: .complete, time: .shortened))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)

                        // Details
                        VStack(alignment: .leading, spacing: 20) {
                            // Description
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Description", systemImage: "text.alignleft")
                                    .font(.headline)

                                Text(moment.description)
                                    .font(.body)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(12)
                            }

                            Divider()

                            // Duration
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Duration", systemImage: "clock.fill")
                                    .font(.headline)

                                HStack {
                                    Image(systemName: "hourglass")
                                        .foregroundColor(moment.category.color)
                                    Text(moment.formattedDuration)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                }
                            }

                            Divider()

                            // Time of day
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Time", systemImage: "calendar.circle")
                                    .font(.headline)

                                HStack {
                                    Text(moment.date, style: .time)
                                        .font(.body)
                                    Text("•")
                                        .foregroundColor(.secondary)
                                    Text(timeOfDayDescription(for: moment.date))
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Done") {
                            dismiss()
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 16) {
                            Button(action: { showingEditView = true }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(Color("AccentColor"))
                            }

                            Button(action: { showingDeleteAlert = true }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .alert("Delete Moment?", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        dataManager.deleteMoment(moment)
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to delete this special moment?")
                }
            }
            .sheet(isPresented: $showingEditView) {
                EditMomentView(moment: moment)
            }
        }
    }
    
    private func timeOfDayDescription(for date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 0..<6:
            return String(localized: "Early Morning", comment: "Time of day description")
        case 6..<12:
            return String(localized: "Morning", comment: "Time of day description")
        case 12..<17:
            return String(localized: "Afternoon", comment: "Time of day description")
        case 17..<21:
            return String(localized: "Evening", comment: "Time of day description")
        default:
            return String(localized: "Night", comment: "Time of day description")
        }
    }
}
