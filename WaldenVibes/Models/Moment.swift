// Moment.swift
import Foundation
import SwiftUI

// MARK: - Moment Model
struct Moment: Identifiable, Codable, Equatable {
    let id: UUID
    let description: String
    let category: MomentCategory
    let duration: Int // in minutes
    let date: Date
    
    init(
        id: UUID = UUID(),
        description: String,
        category: MomentCategory,
        duration: Int,
        date: Date = Date()
    ) {
        self.id = id
        self.description = description
        self.category = category
        self.duration = duration
        self.date = date
    }
}

// MARK: - MomentCategory Enum
enum MomentCategory: String, CaseIterable, Codable {
    case work = "work"
    case family = "family"
    case friends = "friends"
    case personal = "personal"
    case general = "general"
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .work: return "category.work"
        case .family: return "category.family"
        case .friends: return "category.friends"
        case .personal: return "category.personal"
        case .general: return "category.general"
        }
    }
    
    var icon: String {
        switch self {
        case .work: return "briefcase.fill"
        case .family: return "house.fill"
        case .friends: return "person.2.fill"
        case .personal: return "heart.fill"
        case .general: return "star.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .work: return .blue
        case .family: return .green
        case .friends: return .orange
        case .personal: return .pink
        case .general: return .purple
        }
    }
}

// MARK: - Helper Extensions
extension Moment {
    static var sampleData: [Moment] {
        [
            Moment(
                description: "Team meeting went really well, great collaboration",
                category: .work,
                duration: 60,
                date: Date().addingTimeInterval(-86400)
            ),
            Moment(
                description: "Family picnic at the park",
                category: .family,
                duration: 180,
                date: Date().addingTimeInterval(-172800)
            ),
            Moment(
                description: "Coffee with old friends",
                category: .friends,
                duration: 90,
                date: Date().addingTimeInterval(-259200)
            ),
            Moment(
                description: "Morning yoga session",
                category: .personal,
                duration: 45,
                date: Date().addingTimeInterval(-345600)
            )
        ]
    }
    
    var formattedDuration: String {
        if duration < 60 {
            return "\(duration) min"
        } else {
            let hours = duration / 60
            let minutes = duration % 60
            if minutes == 0 {
                return "\(hours)h"
            } else {
                return "\(hours)h \(minutes)min"
            }
        }
    }
}
