// WaldenVibes/Views/Statistics/Components/StressTrendChart.swift
import SwiftUI
import Charts

struct StressTrendChart: View {
    @EnvironmentObject var dataManager: DataManager
    let period: TimePeriod
    
    var chartData: [(date: Date, level: Double)] {
        let filtered = dataManager.stressRecords.filter { isInPeriod($0.date, period: period) }
        return filtered.map { ($0.date, $0.level) }.reversed()
    }
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            VStack(alignment: .leading, spacing: 16) {
                Text("Stress Trend", comment: "Chart title")
                    .font(.headline)
                    .padding(.horizontal)

                if chartData.isEmpty {
                    EmptyChartView(message: LocalizedStringKey("Not enough data yet"))
                } else {
                    Chart(chartData, id: \.date) { item in
                        LineMark(
                            x: .value("Date", item.date),
                            y: .value("Level", item.level)
                        )
                        .foregroundStyle(Color("AccentColor"))
                        .lineStyle(StrokeStyle(lineWidth: 3))

                        AreaMark(
                            x: .value("Date", item.date),
                            y: .value("Level", item.level)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color("AccentColor").opacity(0.3),
                                    Color("AccentColor").opacity(0.1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                    .frame(height: 200)
                    .padding(.horizontal)
                    .chartYScale(domain: 0...10)
                    .chartYAxis {
                        AxisMarks(position: .leading, values: [0, 5, 10])
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisTick()
                            AxisGridLine()
                            AxisValueLabel(format: .dateTime.day().month())
                        }
                    }
                }
            }
            .padding(.vertical)
            .background(.regularMaterial)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.08), radius: 10, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .padding(.horizontal)
        } else {
            // MARK: - iOS 18 Design
            VStack(alignment: .leading, spacing: 16) {
                Text("Stress Trend", comment: "Chart title")
                    .font(.headline)
                    .padding(.horizontal)

                if chartData.isEmpty {
                    EmptyChartView(message: LocalizedStringKey("Not enough data yet"))
                } else {
                    Chart(chartData, id: \.date) { item in
                        LineMark(
                            x: .value("Date", item.date),
                            y: .value("Level", item.level)
                        )
                        .foregroundStyle(Color("AccentColor"))
                        .lineStyle(StrokeStyle(lineWidth: 3))

                        AreaMark(
                            x: .value("Date", item.date),
                            y: .value("Level", item.level)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color("AccentColor").opacity(0.3),
                                    Color("AccentColor").opacity(0.1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                    .frame(height: 200)
                    .padding(.horizontal)
                    .chartYScale(domain: 0...10)
                    .chartYAxis {
                        AxisMarks(position: .leading, values: [0, 5, 10])
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisTick()
                            AxisGridLine()
                            AxisValueLabel(format: .dateTime.day().month())
                        }
                    }
                }
            }
            .padding(.vertical)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
            .padding(.horizontal)
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
