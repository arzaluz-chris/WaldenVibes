// WaldenVibes/Views/Statistics/Components/InsightsSection.swift
import SwiftUI

struct InsightsSection: View {
    @EnvironmentObject var dataManager: DataManager
    let period: TimePeriod
    
    var insights: [String] {
        var insights: [String] = []
        
        // Most productive time
        if let mostProductiveTime = getMostProductiveTime() {
            insights.append(String(localized: "Your most active time for recording emotions is \(mostProductiveTime)", comment: "Insight about most active time"))
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
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            if !insights.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Insights", comment: "Section header for insights")
                        .font(.headline)
                        .padding([.top, .horizontal])
                    
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
                .background(.regularMaterial)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)
            }
        } else {
            // MARK: - iOS 18 Design
            if !insights.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Insights", comment: "Section header for insights")
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
            return String(localized: "Your stress levels have been high. Consider taking breaks and practicing relaxation techniques.", comment: "High stress insight")
        } else if avgStress < 3 {
            return String(localized: "Great job! Your stress levels remain low. Keep up the good practices.", comment: "Low stress insight")
        }
        
        return nil
    }
    
    private func getEmotionPattern() -> String? {
        let frequencies = dataManager.emotionFrequency(for: period)
        
        if let mostFrequent = frequencies.max(by: { $0.value < $1.value }) {
            let total = frequencies.values.reduce(0, +)
            guard total > 0 else { return nil }
            let percentage = Double(mostFrequent.value) / Double(total) * 100
            if percentage > 50 {
                return String(localized: "\(mostFrequent.key.emoji) represents \(Int(percentage))% of your recorded emotions", comment: "Dominant emotion insight")
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
