// WaldenVibes/Models/Stress.swift
import Foundation
import SwiftUI

// MARK: - Stress Model
struct Stress: Identifiable, Codable, Equatable {
    let id: UUID
    let level: Double // 0-10
    let triggers: [StressTrigger]
    let note: String
    let date: Date
    
    init(
        id: UUID = UUID(),
        level: Double,
        triggers: [StressTrigger] = [],
        note: String = "",
        date: Date = Date()
    ) {
        self.id = id
        self.level = min(max(level, 0), 10) // Ensure level is between 0-10
        self.triggers = triggers
        self.note = note
        self.date = date
    }
}

// MARK: - StressTrigger Enum
enum StressTrigger: String, CaseIterable, Codable {
    case work = "work"
    case relationships = "relationships"
    case health = "health"
    case finances = "finances"
    case time = "time"
    case environment = "environment"
    case technology = "technology"
    case other = "other"
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .work: return LocalizedStringKey("Work")
        case .relationships: return LocalizedStringKey("Relationships")
        case .health: return LocalizedStringKey("Health")
        case .finances: return LocalizedStringKey("Finances")
        case .time: return LocalizedStringKey("Time Pressure")
        case .environment: return LocalizedStringKey("Environment")
        case .technology: return LocalizedStringKey("Technology")
        case .other: return LocalizedStringKey("Other")
        }
    }
    
    var icon: String {
        switch self {
        case .work: return "briefcase.fill"
        case .relationships: return "person.2.fill"
        case .health: return "heart.fill"
        case .finances: return "dollarsign.circle.fill"
        case .time: return "clock.fill"
        case .environment: return "leaf.fill"
        case .technology: return "laptopcomputer"
        case .other: return "ellipsis.circle.fill"
        }
    }
}

// MARK: - Helper Extensions
extension Stress {
    static var sampleData: [Stress] {
        [
            Stress(
                level: 7,
                triggers: [.work, .time],
                note: "Deadline approaching for major project",
                date: Date().addingTimeInterval(-86400)
            ),
            Stress(
                level: 4,
                triggers: [.environment],
                note: "Noisy neighbors last night",
                date: Date().addingTimeInterval(-172800)
            ),
            Stress(
                level: 8,
                triggers: [.finances, .work],
                note: "Unexpected expenses this month",
                date: Date().addingTimeInterval(-259200)
            ),
            Stress(
                level: 3,
                triggers: [.technology],
                note: "Computer issues resolved",
                date: Date().addingTimeInterval(-345600)
            )
        ]
    }
    
    var stressColor: Color {
        switch level {
        case 0..<3:
            return Color("StressLow")
        case 3..<5:
            return Color("StressModerate")
        case 5..<7:
            return Color("StressHigh")
        case 7...10:
            return Color("StressVeryHigh")
        default:
            return .gray
        }
    }
    
    var stressEmoji: String {
        switch level {
        case 0..<3:
            return "😌"
        case 3..<5:
            return "😐"
        case 5..<7:
            return "😟"
        case 7...10:
            return "😰"
        default:
            return "🤔"
        }
    }
    
    var stressDescription: LocalizedStringKey {
        switch level {
        case 0..<3:
            return LocalizedStringKey("Low stress")
        case 3..<5:
            return LocalizedStringKey("Moderate stress")
        case 5..<7:
            return LocalizedStringKey("High stress")
        case 7...10:
            return LocalizedStringKey("Very high stress")
        default:
            return LocalizedStringKey("Unknown")
        }
    }
}

// MARK: - Stress Tips
struct StressTip: Identifiable {
    let id = UUID()
    let title: LocalizedStringKey
    let description: LocalizedStringKey
    let icon: String
    
    static let tips: [StressTip] = [
        StressTip(
            title: LocalizedStringKey("Deep Breathing"),
            description: LocalizedStringKey("Take slow, deep breaths to calm your nervous system"),
            icon: "wind"
        ),
        StressTip(
            title: LocalizedStringKey("Physical Activity"),
            description: LocalizedStringKey("Regular exercise releases endorphins that reduce stress"),
            icon: "figure.walk"
        ),
        StressTip(
            title: LocalizedStringKey("Nature Time"),
            description: LocalizedStringKey("Spending time outdoors can lower stress levels"),
            icon: "leaf.fill"
        ),
        StressTip(
            title: LocalizedStringKey("Quality Sleep"),
            description: LocalizedStringKey("Good sleep is essential for managing stress"),
            icon: "moon.fill"
        ),
        StressTip(
            title: LocalizedStringKey("Social Connection"),
            description: LocalizedStringKey("Talking with friends and family can help reduce stress"),
            icon: "person.2.fill"
        ),
        StressTip(
            title: LocalizedStringKey("Mindfulness"),
            description: LocalizedStringKey("Practice being present to reduce anxiety about the future"),
            icon: "brain"
        )
    ]
}
