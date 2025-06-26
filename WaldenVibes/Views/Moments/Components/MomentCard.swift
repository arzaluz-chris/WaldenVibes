//  MomentCard.swift
import SwiftUI

struct MomentCard: View {
    let moment: Moment
    @EnvironmentObject var dataManager: DataManager
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                // Category Icon
                Image(systemName: moment.category.icon)
                    .font(.title2)
                    .foregroundColor(moment.category.color)
                    .frame(width: 40, height: 40)
                    .background(moment.category.color.opacity(0.1))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(moment.category.localizedName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(moment.date, style: .time)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                
                Spacer()
                
                // Duration
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(moment.formattedDuration)
                        .font(.subheadline)
                }
                .foregroundColor(.secondary)
                
                // Delete button
                Button(action: { showingDeleteAlert = true }) {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(.red.opacity(0.7))
                }
            }
            
            // Description
            Text(moment.description)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .alert("delete.confirm.title", isPresented: $showingDeleteAlert) {
            Button("delete", role: .destructive) {
                withAnimation {
                    dataManager.deleteMoment(moment)
                }
            }
            Button("cancel", role: .cancel) {}
        } message: {
            Text("delete.moment.message")
        }
    }
}
