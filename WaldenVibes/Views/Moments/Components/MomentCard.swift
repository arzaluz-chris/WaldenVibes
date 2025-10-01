// WaldenVibes/Views/Moments/Components/MomentCard.swift
import SwiftUI

struct MomentCard: View {
    let moment: Moment
    @State private var isExpanded = false
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    // Category Icon with gradient background
                    ZStack {
                        LinearGradient(
                            colors: [moment.category.color.opacity(0.4), moment.category.color.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .background(.thinMaterial)
                        .frame(width: 50, height: 50)
                        .cornerRadius(15)
                        
                        Image(systemName: moment.category.icon)
                            .font(.title2)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
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
                }
                
                // Description
                Text(moment.description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(isExpanded ? nil : 3)
                
                if moment.description.count > 100 {
                    Button(action: {
                        withAnimation(.spring()) {
                            isExpanded.toggle()
                        }
                    }) {
                        Text(isExpanded ? "Show less" : "Show more")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color("AccentColor"))
                    }
                }
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(20)
            .shadow(color: moment.category.color.opacity(0.1), radius: 10, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(LinearGradient(
                        colors: [.white.opacity(0.5), .white.opacity(0.2)],
                        startPoint: .top,
                        endPoint: .bottom
                    ), lineWidth: 1)
            )
            .padding(.horizontal)

        } else {
            // MARK: - iOS 18 Design
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
        }
    }
}
