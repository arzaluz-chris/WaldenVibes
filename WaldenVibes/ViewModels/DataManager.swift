//  DataManager.swift
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
        case .today: return "period.today"
        case .week: return "period.week"
        case .month: return "period.month"
        case .year: return "period.year"
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
        var exportText = "Walden Vibes - Data Export\n"
        exportText += "Generated: \(Date().formatted())\n\n"
        
        // Export Emotions
        exportText += "=== EMOTIONS ===\n"
        for emotion in emotions {
            exportText += "\nDate: \(emotion.date.formatted())\n"
            exportText += "Emotion: \(emotion.type.rawValue) \(emotion.type.emoji)\n"
            exportText += "Intensity: \(Int(emotion.intensity))/10\n"
            if !emotion.note.isEmpty {
                exportText += "Note: \(emotion.note)\n"
            }
            if let location = emotion.location {
                exportText += "Location: \(location)\n"
            }
            exportText += "---\n"
        }
        
        // Export Moments
        exportText += "\n=== SPECIAL MOMENTS ===\n"
        for moment in moments {
            exportText += "\nDate: \(moment.date.formatted())\n"
            exportText += "Category: \(moment.category.rawValue)\n"
            exportText += "Duration: \(moment.formattedDuration)\n"
            exportText += "Description: \(moment.description)\n"
            exportText += "---\n"
        }
        
        // Export Stress Records
        exportText += "\n=== STRESS RECORDS ===\n"
        for stress in stressRecords {
            exportText += "\nDate: \(stress.date.formatted())\n"
            exportText += "Level: \(Int(stress.level))/10\n"
            if !stress.triggers.isEmpty {
                exportText += "Triggers: \(stress.triggers.map { $0.rawValue }.joined(separator: ", "))\n"
            }
            if !stress.note.isEmpty {
                exportText += "Note: \(stress.note)\n"
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
