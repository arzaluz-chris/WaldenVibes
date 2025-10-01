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
                                Text(period.localizedName)
                                    .tag(period)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)

                        // Summary Cards
                        if horizontalSizeClass == .regular {
                            // iPad: 4 columns
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                                summaryCardsContent
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: 1000)
                        } else {
                            // iPhone: 2 columns
                            SummaryCards(period: selectedPeriod)
                        }

                        // Charts in adaptive grid for iPad
                        if horizontalSizeClass == .regular {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                                EmotionFrequencyChart(period: selectedPeriod)
                                    .frame(minHeight: 300)

                                StressTrendChart(period: selectedPeriod)
                                    .frame(minHeight: 300)

                                EmotionIntensityChart(period: selectedPeriod)
                                    .frame(minHeight: 300)

                                InsightsSection(period: selectedPeriod)
                                    .frame(minHeight: 300)
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: 1200)
                        } else {
                            // iPhone: Vertical stack
                            EmotionFrequencyChart(period: selectedPeriod)
                            StressTrendChart(period: selectedPeriod)
                            EmotionIntensityChart(period: selectedPeriod)
                            InsightsSection(period: selectedPeriod)
                        }
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
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
        } else {
            // MARK: - iOS 18 Design
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
                    .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)

                    // Summary Cards
                    if horizontalSizeClass == .regular {
                        // iPad: 4 columns
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                            summaryCardsContent
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: 1000)
                    } else {
                        // iPhone: 2 columns
                        SummaryCards(period: selectedPeriod)
                    }

                    // Charts in adaptive grid for iPad
                    if horizontalSizeClass == .regular {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                            EmotionFrequencyChart(period: selectedPeriod)
                                .frame(minHeight: 300)

                            StressTrendChart(period: selectedPeriod)
                                .frame(minHeight: 300)

                            EmotionIntensityChart(period: selectedPeriod)
                                .frame(minHeight: 300)

                            InsightsSection(period: selectedPeriod)
                                .frame(minHeight: 300)
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: 1200)
                    } else {
                        // iPhone: Vertical stack
                        EmotionFrequencyChart(period: selectedPeriod)
                        StressTrendChart(period: selectedPeriod)
                        EmotionIntensityChart(period: selectedPeriod)
                        InsightsSection(period: selectedPeriod)
                    }
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(UIColor.systemBackground), for: .navigationBar)
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
    
    @ViewBuilder
    private var summaryCardsContent: some View {
        let totalEmotions = dataManager.emotions.filter { isInPeriod($0.date, period: selectedPeriod) }.count
        let totalMoments = dataManager.moments.filter { isInPeriod($0.date, period: selectedPeriod) }.count
        let averageStress = dataManager.averageStressLevel(for: selectedPeriod)
        let mostFrequentEmotion = dataManager.emotionFrequency(for: selectedPeriod).max(by: { $0.value < $1.value })
        
        StatCard(
            title: LocalizedStringKey("Total Emotions"),
            value: "\(totalEmotions)",
            icon: "heart.fill",
            color: Color("AccentColor")
        )
        
        StatCard(
            title: LocalizedStringKey("Total Moments"),
            value: "\(totalMoments)",
            icon: "star.fill",
            color: .orange
        )
        
        StatCard(
            title: LocalizedStringKey("Average Stress"),
            value: String(format: "%.1f", averageStress),
            icon: "waveform.path.ecg",
            color: colorForStressLevel(averageStress)
        )
        
        if let frequent = mostFrequentEmotion {
            StatCard(
                title: LocalizedStringKey("Most Frequent"),
                value: frequent.key.emoji,
                subtitle: String(localized: "\(frequent.value) times", comment: "Frequency count"),
                icon: "crown.fill",
                color: frequent.key.color
            )
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
