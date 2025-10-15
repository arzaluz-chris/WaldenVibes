// WaldenVibes/Views/Statistics/Components/SummaryCards.swift
import SwiftUI

struct SummaryCards: View {
    @EnvironmentObject var dataManager: DataManager
    let period: TimePeriod
    
    var totalEmotions: Int {
        dataManager.emotions.filter { isInPeriod($0.date, period: period) }.count
    }
    
    var totalMoments: Int {
        dataManager.moments.filter { isInPeriod($0.date, period: period) }.count
    }
    
    var averageStress: Double {
        dataManager.averageStressLevel(for: period)
    }
    
    var mostFrequentEmotion: (type: EmotionType, count: Int)? {
        let frequencies = dataManager.emotionFrequency(for: period)
        return frequencies.max(by: { $0.value < $1.value }).map { ($0.key, $0.value) }
    }
    
    var body: some View {
        // This view's appearance is determined by the StatCard component, which has already been updated.
        // No conditional logic for iOS 26 is needed here.
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            // Total Emotions
            StatCard(
                title: LocalizedStringKey("Total Emotions"),
                value: "\(totalEmotions)",
                icon: "heart.fill",
                color: Color("AccentColor")
            )
            
            // Total Moments
            StatCard(
                title: LocalizedStringKey("Total Moments"),
                value: "\(totalMoments)",
                icon: "star.fill",
                color: .orange
            )
            
            // Average Stress
            StatCard(
                title: LocalizedStringKey("Average Stress"),
                value: String(format: "%.1f", averageStress),
                icon: "waveform.path.ecg",
                color: colorForStressLevel(averageStress)
            )
            
            // Most Frequent Emotion
            if let frequent = mostFrequentEmotion {
                StatCard(
                    title: LocalizedStringKey("Most Frequent"),
                    value: frequent.type.emoji,
                    subtitle: String(localized: "\(frequent.count) times", comment: "Frequency count"),
                    icon: "crown.fill",
                    color: frequent.type.color
                )
            }
        }
        .padding(.horizontal)
    }
    
    private func colorForStressLevel(_ level: Double) -> Color {
        switch level {
        case 0..<3: return Color("StressLow")
        case 3..<5: return Color("StressModerate")
        case 5..<7: return Color("StressHigh")
        case 7...10: return Color("StressVeryHigh")
        default: return .gray
        }
    }
    
    private func isInPeriod(_ date: Date, period: TimePeriod) -> Bool {
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
