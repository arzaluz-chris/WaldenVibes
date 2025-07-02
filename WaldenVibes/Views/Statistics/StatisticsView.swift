// WaldenVibes/Views/Statistics/StatisticsView.swift
import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedPeriod: TimePeriod = .week
    @State private var showingExport = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Period Selector
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        Text(period.localizedName)
                            .tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Summary Cards
                SummaryCards(period: selectedPeriod)
                
                // Emotion Frequency Chart
                EmotionFrequencyChart(period: selectedPeriod)
                
                // Stress Trend Chart
                StressTrendChart(period: selectedPeriod)
                
                // Emotion Intensity Chart
                EmotionIntensityChart(period: selectedPeriod)
                
                // Insights
                InsightsSection(period: selectedPeriod)
            }
            .padding(.vertical)
        }
        .navigationTitle("Statistics")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingExport = true }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingExport) {
            ExportView()
        }
    }
}
