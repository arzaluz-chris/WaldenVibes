//  InsightsSection.swift
import SwiftUI

struct InsightsSection: View {
    @EnvironmentObject var dataManager: DataManager
    let period: TimePeriod
    
    var insights: [String] {
        var insights: [String] = []
        
        // Most productive time
        if let mostProductiveTime = getMostProductiveTime() {
            insights.append(String(format: NSLocalizedString("insight.productive.time", comment: ""), mostProductiveTime))
        }
        
        // Stress pattern
        if let stressPattern = getStressPattern() {
            insights.append(stressPattern)
        }
        
        // Emotion pattern
        if let emotionPattern = getEmotionPattern() {
            insights.append(emotionPattern)
        }
        
        return insights
    }
    
    var body: some View {
        if !insights.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text("stats.insights")
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(insights, id: \.self) { insight in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.subheadline)
                            
                            Text(insight)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding()
            }
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
    
    private func getMostProductiveTime() -> String? {
        let calendar = Calendar.current
        let emotions = dataManager.emotions.filter { isInPeriod($0.date, period: period) }
        
        guard !emotions.isEmpty else { return nil }
        
        let hourCounts = emotions.reduce(into: [Int: Int]()) { counts, emotion in
            let hour = calendar.component(.hour, from: emotion.date)
            counts[hour, default: 0] += 1
        }
        
        if let mostActiveHour = hourCounts.max(by: { $0.value < $1.value })?.key {
            let formatter = DateFormatter()
            formatter.dateFormat = "ha"
            let date = calendar.date(bySettingHour: mostActiveHour, minute: 0, second: 0, of: Date())!
            return formatter.string(from: date)
        }
        
        return nil
    }
    
    private func getStressPattern() -> String? {
        let avgStress = dataManager.averageStressLevel(for: period)
        
        if avgStress > 7 {
            return NSLocalizedString("insight.stress.high", comment: "")
        } else if avgStress < 3 {
            return NSLocalizedString("insight.stress.low", comment: "")
        }
        
        return nil
    }
    
    private func getEmotionPattern() -> String? {
        let frequencies = dataManager.emotionFrequency(for: period)
        
        if let mostFrequent = frequencies.max(by: { $0.value < $1.value }) {
            let percentage = Double(mostFrequent.value) / Double(frequencies.values.reduce(0, +)) * 100
            if percentage > 50 {
                return String(format: NSLocalizedString("insight.emotion.dominant", comment: ""),
                            mostFrequent.key.emoji,
                            Int(percentage))
            }
        }
        
        return nil
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
