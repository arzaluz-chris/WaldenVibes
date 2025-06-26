//  Stress.swift
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
        case .work: return "trigger.work"
        case .relationships: return "trigger.relationships"
        case .health: return "trigger.health"
        case .finances: return "trigger.finances"
        case .time: return "trigger.time"
        case .environment: return "trigger.environment"
        case .technology: return "trigger.technology"
        case .other: return "trigger.other"
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
            return "stress.level.low"
        case 3..<5:
            return "stress.level.moderate"
        case 5..<7:
            return "stress.level.high"
        case 7...10:
            return "stress.level.veryhigh"
        default:
            return "stress.level.unknown"
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
            title: "tip.breathing.title",
            description: "tip.breathing.description",
            icon: "wind"
        ),
        StressTip(
            title: "tip.exercise.title",
            description: "tip.exercise.description",
            icon: "figure.walk"
        ),
        StressTip(
            title: "tip.nature.title",
            description: "tip.nature.description",
            icon: "leaf.fill"
        ),
        StressTip(
            title: "tip.sleep.title",
            description: "tip.sleep.description",
            icon: "moon.fill"
        ),
        StressTip(
            title: "tip.social.title",
            description: "tip.social.description",
            icon: "person.2.fill"
        ),
        StressTip(
            title: "tip.mindfulness.title",
            description: "tip.mindfulness.description",
            icon: "brain"
        )
    ]
}
