// WaldenVibes/Views/Statistics/Components/EmmotionFrecuencyChart.swift
import SwiftUI
import Charts

struct EmotionFrequencyChart: View {
    @EnvironmentObject var dataManager: DataManager
    let period: TimePeriod
    
    var chartData: [(type: EmotionType, count: Int)] {
        let frequencies = dataManager.emotionFrequency(for: period)
        return frequencies.map { ($0.key, $0.value) }.sorted { $0.count > $1.count }
    }
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            VStack(alignment: .leading, spacing: 16) {
                Text("Emotion Frequency", comment: "Chart title")
                    .font(.headline)
                    .padding([.top, .horizontal])
                
                if chartData.isEmpty {
                    EmptyChartView(message: LocalizedStringKey("Not enough data yet"))
                } else {
                    Chart(chartData, id: \.type) { item in
                        BarMark(
                            x: .value("Emotion", item.type.emoji),
                            y: .value("Count", item.count)
                        )
                        .foregroundStyle(item.type.color)
                        .cornerRadius(8)
                    }
                    .frame(height: 200)
                    .padding(.horizontal)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                }
            }
            .padding(.bottom)
            .background(.regularMaterial)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal)

        } else {
            // MARK: - iOS 18 Design
            VStack(alignment: .leading, spacing: 16) {
                Text("Emotion Frequency", comment: "Chart title")
                    .font(.headline)
                    .padding(.horizontal)
                
                if chartData.isEmpty {
                    EmptyChartView(message: LocalizedStringKey("Not enough data yet"))
                } else {
                    Chart(chartData, id: \.type) { item in
                        BarMark(
                            x: .value("Emotion", item.type.emoji),
                            y: .value("Count", item.count)
                        )
                        .foregroundStyle(item.type.color)
                        .cornerRadius(8)
                    }
                    .frame(height: 200)
                    .padding(.horizontal)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                }
            }
            .padding(.vertical)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
}

// MARK: - Empty Chart View
struct EmptyChartView: View {
    let message: LocalizedStringKey
    
    var body: some View {
        VStack {
            Image(systemName: "chart.bar")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }
}
