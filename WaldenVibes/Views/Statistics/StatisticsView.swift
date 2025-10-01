// WaldenVibes/Views/Statistics/StatisticsView.swift
import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedPeriod: TimePeriod = .week
    @State private var showingExport = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            ZStack {
                AnimatedGlassBackground(color: Color("AccentColor"))
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Period Selector
                        Picker("Period", selection: $selectedPeriod) {
                            ForEach(TimePeriod.allCases, id: \.self) { period in
                                Text(period.localizedName).tag(period)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .background(.thinMaterial)
                        .cornerRadius(8)
                        .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)
                        
                        // Summary Cards
                        if horizontalSizeClass == .regular {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                                summaryCardsContent
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: 1000)
                        } else {
                            SummaryCards(period: selectedPeriod)
                        }
                        
                        // Charts
                        chartsContent
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Statistics")
            .toolbar { navigationToolbar }
            .sheet(isPresented: $showingExport) { ExportView() }

        } else {
            // MARK: - iOS 18 Design
            ScrollView {
                VStack(spacing: 24) {
                    Picker("Period", selection: $selectedPeriod) {
                        ForEach(TimePeriod.allCases, id: \.self) { period in Text(period.localizedName).tag(period) }
                    }
                    .pickerStyle(SegmentedPickerStyle()).padding(.horizontal)
                    .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)
                    
                    if horizontalSizeClass == .regular {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                            summaryCardsContent
                        }.padding(.horizontal).frame(maxWidth: 1000)
                    } else {
                        SummaryCards(period: selectedPeriod)
                    }
                    
                    if horizontalSizeClass == .regular {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                            chartContentWithFrame
                        }.padding(.horizontal).frame(maxWidth: 1200)
                    } else {
                        EmotionFrequencyChart(period: selectedPeriod)
                        StressTrendChart(period: selectedPeriod)
                        EmotionIntensityChart(period: selectedPeriod)
                        InsightsSection(period: selectedPeriod)
                    }
                }
                .padding(.vertical).frame(maxWidth: .infinity)
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(horizontalSizeClass == .regular ? .large : .automatic)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(UIColor.systemBackground), for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingExport = true }) { Image(systemName: "square.and.arrow.up") }
                }
            }
            .sheet(isPresented: $showingExport) { ExportView() }
        }
    }
    
    @ViewBuilder
    private var summaryCardsContent: some View {
        let emotions = dataManager.emotions.filter { $0.date.isInPeriod(selectedPeriod) }
        let moments = dataManager.moments.filter { $0.date.isInPeriod(selectedPeriod) }
        let avgStress = dataManager.averageStressLevel(for: selectedPeriod)
        let freqEmotion = dataManager.emotionFrequency(for: selectedPeriod).max(by: { $0.value < $1.value })
        
        StatCard(title: "Total Emotions", value: "\(emotions.count)", icon: "heart.fill", color: Color("AccentColor"))
        StatCard(title: "Total Moments", value: "\(moments.count)", icon: "star.fill", color: .orange)
        StatCard(title: "Average Stress", value: String(format: "%.1f", avgStress), icon: "waveform.path.ecg", color: colorForStressLevel(avgStress))
        
        if let frequent = freqEmotion {
            StatCard(title: "Most Frequent", value: frequent.key.emoji, subtitle: String(localized: "\(frequent.value) times", comment: "Frequency count"), icon: "crown.fill", color: frequent.key.color)
        }
    }

    @available(iOS 26.0, *)
    @ViewBuilder
    private var chartsContent: some View {
        if horizontalSizeClass == .regular {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                chartContentWithFrame
            }
            .padding(.horizontal)
            .frame(maxWidth: 1200)
        } else {
            EmotionFrequencyChart(period: selectedPeriod)
            StressTrendChart(period: selectedPeriod)
            EmotionIntensityChart(period: selectedPeriod)
            InsightsSection(period: selectedPeriod)
        }
    }
    
    @ViewBuilder
    private var chartContentWithFrame: some View {
        EmotionFrequencyChart(period: selectedPeriod).frame(minHeight: 300)
        StressTrendChart(period: selectedPeriod).frame(minHeight: 300)
        EmotionIntensityChart(period: selectedPeriod).frame(minHeight: 300)
        InsightsSection(period: selectedPeriod).frame(minHeight: 300)
    }
    
    @ToolbarContentBuilder
    private var navigationToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showingExport = true }) { Image(systemName: "square.and.arrow.up") }
        }
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
}
