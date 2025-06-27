// MomentCard.swift - Redesigned
import SwiftUI

struct MomentCard: View {
    let moment: Moment
    @EnvironmentObject var dataManager: DataManager
    @State private var showingDeleteAlert = false
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                // Category Icon with gradient background
                ZStack {
                    LinearGradient(
                        colors: [moment.category.color, moment.category.color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: 50, height: 50)
                    .cornerRadius(15)
                    
                    Image(systemName: moment.category.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(moment.category.localizedName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(moment.date, style: .time)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption2)
                            Text(moment.formattedDuration)
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // More menu
                Menu {
                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .frame(width: 30, height: 30)
                }
            }
            
            // Description
            Text(moment.description)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(isExpanded ? nil : 3)
                .animation(.easeInOut, value: isExpanded)
            
            if moment.description.count > 100 {
                Button(action: { isExpanded.toggle() }) {
                    Text(isExpanded ? "Show less" : "Show more")
                        .font(.caption)
                        .foregroundColor(Color("AccentColor"))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: moment.category.color.opacity(0.1), radius: 5, x: 0, y: 2)
        )
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
