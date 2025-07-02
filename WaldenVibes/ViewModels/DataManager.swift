// WaldenVibes/ViewModels/DataManager.swift
import Foundation
import SwiftUI

// MARK: - Time Period Enum
enum TimePeriod: String, CaseIterable {
    case today = "today"
    case week = "week"
    case month = "month"
    case year = "year"
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .today: return LocalizedStringKey("Today")
        case .week: return LocalizedStringKey("Week")
        case .month: return LocalizedStringKey("Month")
        case .year: return LocalizedStringKey("Year")
        }
    }
}

// MARK: - DataManager
class DataManager: ObservableObject {
    static let shared = DataManager()
    
    // Published properties for real-time updates
    @Published var emotions: [Emotion] = []
    @Published var moments: [Moment] = []
    @Published var stressRecords: [Stress] = []
    
    // UserDefaults keys
    private let emotionsKey = "walden_emotions"
    private let momentsKey = "walden_moments"
    private let stressKey = "walden_stress"
    
    private init() {
        loadData()
    }
    
    // MARK: - Load Data
    private func loadData() {
        loadEmotions()
        loadMoments()
        loadStressRecords()
    }
    
    private func loadEmotions() {
        if let data = UserDefaults.standard.data(forKey: emotionsKey),
           let decoded = try? JSONDecoder().decode([Emotion].self, from: data) {
            emotions = decoded
        }
    }
    
    private func loadMoments() {
        if let data = UserDefaults.standard.data(forKey: momentsKey),
           let decoded = try? JSONDecoder().decode([Moment].self, from: data) {
            moments = decoded
        }
    }
    
    private func loadStressRecords() {
        if let data = UserDefaults.standard.data(forKey: stressKey),
           let decoded = try? JSONDecoder().decode([Stress].self, from: data) {
            stressRecords = decoded
        }
    }
    
    // MARK: - Save Data
    func saveEmotions() {
        if let encoded = try? JSONEncoder().encode(emotions) {
            UserDefaults.standard.set(encoded, forKey: emotionsKey)
        }
    }
    
    func saveMoments() {
        if let encoded = try? JSONEncoder().encode(moments) {
            UserDefaults.standard.set(encoded, forKey: momentsKey)
        }
    }
    
    func saveStressRecords() {
        if let encoded = try? JSONEncoder().encode(stressRecords) {
            UserDefaults.standard.set(encoded, forKey: stressKey)
        }
    }
    
    // MARK: - Add Records
    func addEmotion(_ emotion: Emotion) {
        emotions.insert(emotion, at: 0)
        saveEmotions()
    }
    
    func addMoment(_ moment: Moment) {
        moments.insert(moment, at: 0)
        saveMoments()
    }
    
    func addStressRecord(_ stress: Stress) {
        stressRecords.insert(stress, at: 0)
        saveStressRecords()
    }
    
    // MARK: - Delete Records
    func deleteEmotion(_ emotion: Emotion) {
        emotions.removeAll { $0.id == emotion.id }
        saveEmotions()
    }
    
    func deleteMoment(_ moment: Moment) {
        moments.removeAll { $0.id == moment.id }
        saveMoments()
    }
    
    func deleteStressRecord(_ stress: Stress) {
        stressRecords.removeAll { $0.id == stress.id }
        saveStressRecords()
    }
    
    // MARK: - Clear All Data
    func clearAllData() {
        emotions.removeAll()
        moments.removeAll()
        stressRecords.removeAll()
        
        UserDefaults.standard.removeObject(forKey: emotionsKey)
        UserDefaults.standard.removeObject(forKey: momentsKey)
        UserDefaults.standard.removeObject(forKey: stressKey)
    }
    
    // MARK: - Export Data
    func exportAllData() -> String {
        var exportText = String(localized: "Walden Vibes - Data Export", comment: "Export file header")
        exportText += "\n"
        exportText += String(localized: "Generated: \(Date().formatted())", comment: "Export generation date")
        exportText += "\n\n"
        
        // Export Emotions
        exportText += String(localized: "=== EMOTIONS ===", comment: "Emotions section header in export")
        exportText += "\n"
        for emotion in emotions {
            exportText += "\n"
            exportText += String(localized: "Date: \(emotion.date.formatted())", comment: "Date label in export")
            exportText += "\n"
            exportText += String(localized: "Emotion: \(emotion.type.rawValue) \(emotion.type.emoji)", comment: "Emotion type in export")
            exportText += "\n"
            exportText += String(localized: "Intensity: \(Int(emotion.intensity))/10", comment: "Intensity in export")
            exportText += "\n"
            if !emotion.note.isEmpty {
                exportText += String(localized: "Note: \(emotion.note)", comment: "Note in export")
                exportText += "\n"
            }
            if let location = emotion.location {
                exportText += String(localized: "Location: \(location)", comment: "Location in export")
                exportText += "\n"
            }
            exportText += "---\n"
        }
        
        // Export Moments
        exportText += "\n"
        exportText += String(localized: "=== SPECIAL MOMENTS ===", comment: "Moments section header in export")
        exportText += "\n"
        for moment in moments {
            exportText += "\n"
            exportText += String(localized: "Date: \(moment.date.formatted())", comment: "Date label in export")
            exportText += "\n"
            exportText += String(localized: "Category: \(moment.category.rawValue)", comment: "Category in export")
            exportText += "\n"
            exportText += String(localized: "Duration: \(moment.formattedDuration)", comment: "Duration in export")
            exportText += "\n"
            exportText += String(localized: "Description: \(moment.description)", comment: "Description in export")
            exportText += "\n"
            exportText += "---\n"
        }
        
        // Export Stress Records
        exportText += "\n"
        exportText += String(localized: "=== STRESS RECORDS ===", comment: "Stress section header in export")
        exportText += "\n"
        for stress in stressRecords {
            exportText += "\n"
            exportText += String(localized: "Date: \(stress.date.formatted())", comment: "Date label in export")
            exportText += "\n"
            exportText += String(localized: "Level: \(Int(stress.level))/10", comment: "Stress level in export")
            exportText += "\n"
            if !stress.triggers.isEmpty {
                let triggersList = stress.triggers.map { $0.rawValue }.joined(separator: ", ")
                exportText += String(localized: "Triggers: \(triggersList)", comment: "Triggers in export")
                exportText += "\n"
            }
            if !stress.note.isEmpty {
                exportText += String(localized: "Note: \(stress.note)", comment: "Note in export")
                exportText += "\n"
            }
            exportText += "---\n"
        }
        
        return exportText
    }
    
    // MARK: - Analytics Functions
    func emotionFrequency(for period: TimePeriod) -> [EmotionType: Int] {
        let filteredEmotions = emotions.filter { isWithinPeriod($0.date, period: period) }
        var frequency: [EmotionType: Int] = [:]
        
        for emotion in filteredEmotions {
            frequency[emotion.type, default: 0] += 1
        }
        
        return frequency
    }
    
    func averageIntensity(for emotionType: EmotionType, period: TimePeriod) -> Double {
        let filteredEmotions = emotions
            .filter { $0.type == emotionType && isWithinPeriod($0.date, period: period) }
        
        guard !filteredEmotions.isEmpty else { return 0 }
        
        let totalIntensity = filteredEmotions.reduce(0) { $0 + $1.intensity }
        return totalIntensity / Double(filteredEmotions.count)
    }
    
    func averageStressLevel(for period: TimePeriod) -> Double {
        let filteredRecords = stressRecords.filter { isWithinPeriod($0.date, period: period) }
        
        guard !filteredRecords.isEmpty else { return 0 }
        
        let totalStress = filteredRecords.reduce(0) { $0 + $1.level }
        return totalStress / Double(filteredRecords.count)
    }
    
    private func isWithinPeriod(_ date: Date, period: TimePeriod) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        switch period {
        case .today:
            return calendar.isDateInToday(date)
        case .week:
            guard let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) else { return false }
            return date >= weekAgo
        case .month:
            guard let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) else { return false }
            return date >= monthAgo
        case .year:
            guard let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) else { return false }
            return date >= yearAgo
        }
    }
}
