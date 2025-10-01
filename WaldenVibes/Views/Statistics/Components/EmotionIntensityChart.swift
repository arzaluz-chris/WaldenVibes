// WaldenVibes/Views/Statistics/Components/EmotionIntensityChart.swift
import SwiftUI

struct EmotionIntensityChart: View {
    @EnvironmentObject var dataManager: DataManager
    let period: TimePeriod
    
    var chartData: [(type: EmotionType, avgIntensity: Double)] {
        EmotionType.allCases.compactMap { type in
            let avg = dataManager.averageIntensity(for: type, period: period)
            return avg > 0 ? (type, avg) : nil
        }
    }
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            VStack(alignment: .leading, spacing: 16) {
                Text("Average Intensity", comment: "Chart title")
                    .font(.headline)
                    .padding(.horizontal)

                if chartData.isEmpty {
                    EmptyChartView(message: LocalizedStringKey("Not enough data yet"))
                } else {
                    VStack(spacing: 12) {
                        ForEach(chartData, id: \.type) { item in
                            HStack {
                                Text(item.type.emoji)
                                    .font(.title2)

                                Text(item.type.localizedName)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Spacer()

                                // Intensity bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.gray.opacity(0.15))
                                            .frame(height: 20)

                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(item.type.color)
                                            .frame(width: geometry.size.width * (item.avgIntensity / 10), height: 20)
                                            .shadow(color: item.type.color.opacity(0.4), radius: 4, y: 2)
                                    }
                                }
                                .frame(width: 100, height: 20)

                                Text(String(format: "%.1f", item.avgIntensity))
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .frame(width: 35, alignment: .trailing)
                            }
                        }
                    }
                    .padding(.horizontal)
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
                Text("Average Intensity", comment: "Chart title")
                    .font(.headline)
                    .padding(.horizontal)

                if chartData.isEmpty {
                    EmptyChartView(message: LocalizedStringKey("Not enough data yet"))
                } else {
                    VStack(spacing: 12) {
                        ForEach(chartData, id: \.type) { item in
                            HStack {
                                Text(item.type.emoji)
                                    .font(.title2)

                                Text(item.type.localizedName)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Spacer()

                                // Intensity bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 20)

                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(item.type.color)
                                            .frame(width: geometry.size.width * (item.avgIntensity / 10), height: 20)
                                    }
                                }
                                .frame(width: 100, height: 20)

                                Text(String(format: "%.1f", item.avgIntensity))
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .frame(width: 35, alignment: .trailing)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
}
