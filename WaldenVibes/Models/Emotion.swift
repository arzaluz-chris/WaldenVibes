// WaldenVibes/Models/Emotion.swift
import Foundation
import SwiftUI

// MARK: - Emotion Model
struct Emotion: Identifiable, Codable, Equatable {
    let id: UUID
    let type: EmotionType
    let intensity: Double
    let note: String
    let date: Date
    let location: String?
    
    init(
        id: UUID = UUID(),
        type: EmotionType,
        intensity: Double,
        note: String = "",
        date: Date = Date(),
        location: String? = nil
    ) {
        self.id = id
        self.type = type
        self.intensity = intensity
        self.note = note
        self.date = date
        self.location = location
    }
}

// MARK: - EmotionType Enum
enum EmotionType: String, CaseIterable, Codable {
    case happy = "happy"
    case sad = "sad"
    case anxious = "anxious"
    case calm = "calm"
    case angry = "angry"
    case excited = "excited"
    case tired = "tired"
    case grateful = "grateful"
    
    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .sad: return "😢"
        case .anxious: return "😰"
        case .calm: return "😌"
        case .angry: return "😡"
        case .excited: return "🤩"
        case .tired: return "😴"
        case .grateful: return "🙏"
        }
    }
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .happy: return LocalizedStringKey("Happy")
        case .sad: return LocalizedStringKey("Sad")
        case .anxious: return LocalizedStringKey("Anxious")
        case .calm: return LocalizedStringKey("Calm")
        case .angry: return LocalizedStringKey("Angry")
        case .excited: return LocalizedStringKey("Excited")
        case .tired: return LocalizedStringKey("Tired")
        case .grateful: return LocalizedStringKey("Grateful")
        }
    }
    
    var color: Color {
        switch self {
        case .happy: return Color("EmotionHappy")
        case .sad: return Color("EmotionSad")
        case .anxious: return Color("EmotionAnxious")
        case .calm: return Color("EmotionCalm")
        case .angry: return Color("EmotionAngry")
        case .excited: return Color("EmotionExcited")
        case .tired: return Color("EmotionTired")
        case .grateful: return Color("EmotionGrateful")
        }
    }
    
    var gradient: LinearGradient {
        LinearGradient(
            colors: [color.opacity(0.8), color],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Helper Extensions
extension Emotion {
    static var sampleData: [Emotion] {
        [
            Emotion(type: .happy, intensity: 8, note: "Great day at work!", date: Date().addingTimeInterval(-86400)),
            Emotion(type: .anxious, intensity: 6, note: "Presentation tomorrow", date: Date().addingTimeInterval(-172800)),
            Emotion(type: .calm, intensity: 7, note: "Morning meditation helped", date: Date().addingTimeInterval(-259200)),
            Emotion(type: .grateful, intensity: 9, note: "Family dinner was wonderful", date: Date().addingTimeInterval(-345600))
        ]
    }
}
