// WaldenVibes/Views/Moments/MomentDetailView.swift
import SwiftUI

struct MomentDetailView: View {
    let moment: Moment
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var showingDeleteAlert = false
    @State private var showingEditView = false
    
    var body: some View {
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
