// WaldenVibes/Views/Stress/StressTestView.swift
import SwiftUI

struct StressTestView: View {
    @StateObject private var testManager = StressTestManager.shared
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var showingResult = false
    @State private var showingIntroduction = true
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            NavigationView {
                ZStack {
                    AnimatedGlassBackground(color: Color("AccentColor")).ignoresSafeArea()
                    
                    if showingIntroduction {
                        introductionView
                    } else if testManager.isTestComplete {
                        resultView
                    } else {
                        testView
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { navigationToolbar }
                .navigationTitle("Stress Assessment")
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            }
        } else {
            // MARK: - iOS 18 Design
            NavigationView {
                ZStack {
                    LinearGradient(colors: [Color("AccentColor").opacity(0.1), .clear], startPoint: .top, endPoint: .center).ignoresSafeArea()
                    
                    if showingIntroduction {
                        introductionView
                    } else if testManager.isTestComplete {
                        resultView
                    } else {
                        testView
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                    if !showingIntroduction && !testManager.isTestComplete {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Text("\(testManager.currentQuestionIndex + 1)/\(testManager.questions.count)")
                                .font(.subheadline).foregroundColor(.secondary)
                        }
                    }
                }
                .navigationTitle("Stress Assessment")
                .toolbarBackground(Color(.systemBackground), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }

    @ToolbarContentBuilder
    private var navigationToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
        ToolbarItem(placement: .navigationBarTrailing) {
            if !showingIntroduction && !testManager.isTestComplete {
                Text("\(testManager.currentQuestionIndex + 1)/\(testManager.questions.count)")
                    .font(.subheadline).foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Introduction View
    private var introductionView: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerContent
                cardsContent
                instructionsContent
                startButton
                Spacer(minLength: 40)
            }
        }
    }
    
    private var headerContent: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 60))
                .foregroundColor(Color("AccentColor"))
            
            Text("Stress Level Assessment", comment: "Stress test introduction title")
                .font(.title2).fontWeight(.semibold).multilineTextAlignment(.center)
            
            Text("This quick assessment will help us understand your current stress level more accurately.", comment: "Stress test introduction description")
                .font(.body).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal)
        }
        .padding(.top, 40)
    }

    private var cardsContent: some View {
        VStack(spacing: 16) {
            InfoCard(icon: "clock.fill", title: LocalizedStringKey("Quick & Easy"), description: LocalizedStringKey("Takes only 3-5 minutes to complete"))
            InfoCard(icon: "lock.shield.fill", title: LocalizedStringKey("Private & Secure"), description: LocalizedStringKey("Your answers stay on your device"))
            InfoCard(icon: "chart.line.uptrend.xyaxis", title: LocalizedStringKey("Personalized Results"), description: LocalizedStringKey("Get insights and recommendations based on your responses"))
        }
        .padding(.horizontal)
    }

    private var instructionsContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How it works:", comment: "Instructions header").font(.headline)
            Text("• Answer honestly based on how you've been feeling lately", comment: "Instruction 1")
            Text("• There are no right or wrong answers", comment: "Instruction 2")
            Text("• The assessment covers different aspects of stress", comment: "Instruction 3")
            Text("• You'll get a personalized stress level and tips", comment: "Instruction 4")
        }
        .font(.subheadline).foregroundColor(.secondary).padding()
        .background(
            ZStack {
                if #available(iOS 26.0, *) {
                    RoundedRectangle(cornerRadius: 16).fill(.thinMaterial)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.2), lineWidth: 1))
                } else {
                    RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground))
                }
            }
        )
        .padding(.horizontal)
    }

    private var startButton: some View {
        Button(action: {
            withAnimation {
                showingIntroduction = false
                testManager.startTest()
            }
        }) {
            Text("Start Assessment", comment: "Button to start stress test")
                .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding()
                .background(
                    ZStack {
                        if #available(iOS 26.0, *) {
                            Color("AccentColor").opacity(0.8).background(.regularMaterial)
                        } else {
                            Color("AccentColor")
                        }
                    }
                )
                .cornerRadius(12)
        }
        .padding(.horizontal).padding(.top, 20)
    }
    
    // MARK: - Test View
    private var testView: some View {
        VStack(spacing: 0) {
            progressBar
            
            ScrollView {
                VStack(spacing: 24) {
                    if let question = testManager.currentQuestion {
                        questionContent(question: question)
                    }
                    Spacer(minLength: 100)
                }
            }
            
            navigationButtons
        }
    }

    private var progressBar: some View {
        VStack(spacing: 8) {
            ProgressView(value: testManager.progress).progressViewStyle(LinearProgressViewStyle(tint: Color("AccentColor"))).frame(height: 8).padding(.horizontal)
            HStack {
                Text("Question \(testManager.currentQuestionIndex + 1) of \(testManager.questions.count)", comment: "Progress indicator")
                    .font(.caption).foregroundColor(.secondary)
                Spacer()
            }.padding(.horizontal)
        }
        .padding(.vertical)
        .background(
            ZStack {
                if #available(iOS 26.0, *) {
                    Color.clear.background(.ultraThinMaterial)
                } else {
                    Color(UIColor.systemBackground)
                }
            }
        )
    }

    private func questionContent(question: StressTestQuestion) -> some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: question.category.icon).foregroundColor(question.category.color)
                Text(question.category.localizedName).font(.subheadline).foregroundColor(question.category.color)
                Spacer()
            }.padding(.horizontal).padding(.top)
            
            Text(question.questionText).font(.title3).fontWeight(.medium).multilineTextAlignment(.center).padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(question.options) { option in
                    OptionButton(option: option, isSelected: testManager.selectedAnswer == option.value) {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        testManager.answerQuestion(questionId: question.id, value: option.value)
                    }
                }
            }.padding(.horizontal)
        }
        .padding()
        .background(
            ZStack {
                if #available(iOS 26.0, *) {
                    RoundedRectangle(cornerRadius: 20).fill(.regularMaterial)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.3), lineWidth: 1))
                }
            }
        )
        .padding()
    }

    private var navigationButtons: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                if testManager.currentQuestionIndex > 0 {
                    previousButton
                }
                nextButton
            }
            .padding(.horizontal).padding(.bottom)
        }
        .background(
             ZStack {
                if #available(iOS 26.0, *) {
                    Color.clear.background(.ultraThinMaterial)
                } else {
                    Color(UIColor.systemBackground)
                }
            }
        )
    }

    private var previousButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            testManager.previousQuestion()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Previous", comment: "Previous question button")
            }
            .font(.subheadline).foregroundColor(Color("AccentColor")).padding().frame(maxWidth: .infinity)
            .background(
                ZStack {
                    if #available(iOS 26.0, *) {
                        RoundedRectangle(cornerRadius: 12).fill(.thinMaterial)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("AccentColor"), lineWidth: 1.5))
                    } else {
                        RoundedRectangle(cornerRadius: 12).stroke(Color("AccentColor"), lineWidth: 1)
                    }
                }
            )
        }
    }

    private var nextButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            testManager.nextQuestion()
        }) {
            HStack {
                Text(testManager.currentQuestionIndex == testManager.questions.count - 1 ? LocalizedStringKey("Finish") : LocalizedStringKey("Next"))
                if testManager.currentQuestionIndex < testManager.questions.count - 1 { Image(systemName: "chevron.right") }
            }
            .font(.subheadline).fontWeight(.medium).foregroundColor(.white).padding().frame(maxWidth: .infinity)
            .background(
                ZStack {
                    if #available(iOS 26.0, *) {
                        RoundedRectangle(cornerRadius: 12).fill(testManager.canProceed() ? Color("AccentColor").opacity(0.8) : .gray.opacity(0.5))
                            .background(.regularMaterial).clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        RoundedRectangle(cornerRadius: 12).fill(testManager.canProceed() ? Color("AccentColor") : .gray)
                    }
                }
            )
        }
        .disabled(!testManager.canProceed())
    }
    
    // MARK: - Result View
    private var resultView: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let result = testManager.testResult {
                    resultHeader
                    stressLevelResult(result: result)
                    categoryBreakdown(result: result)
                    if !result.recommendations.isEmpty { recommendationsSection(result: result) }
                    saveButton(result: result)
                    Spacer(minLength: 40)
                }
            }
        }
    }

    private var resultHeader: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill").font(.system(size: 60)).foregroundColor(.green)
            Text("Assessment Complete", comment: "Test completion title").font(.title2).fontWeight(.semibold)
            Text("Based on your responses, here's your stress assessment:", comment: "Result introduction")
                .font(.body).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal)
        }.padding(.top, 20)
    }

    private func stressLevelResult(result: StressTestResult) -> some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Text("Your Stress Level", comment: "Stress level section title").font(.headline)
                ZStack {
                    Circle().stroke(.gray.opacity(0.3), lineWidth: 20).frame(width: 200, height: 200)
                    Circle().trim(from: 0, to: result.stressLevel / 10).stroke(result.stressColor, lineWidth: 20)
                        .frame(width: 200, height: 200).rotationEffect(.degrees(-90))
                    VStack {
                        Text(String(format: "%.1f", result.stressLevel)).font(.system(size: 42, weight: .bold, design: .rounded)).foregroundColor(result.stressColor)
                        Text("/ 10").font(.title3).foregroundColor(.secondary)
                    }
                }
                Text(result.stressDescription).font(.title3).fontWeight(.medium).foregroundColor(result.stressColor)
            }
            .padding()
            .background(
                ZStack {
                    if #available(iOS 26.0, *) {
                        RoundedRectangle(cornerRadius: 20).fill(.regularMaterial)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.3), lineWidth: 1))
                    } else {
                        RoundedRectangle(cornerRadius: 16).fill(Color(UIColor.secondarySystemBackground))
                    }
                }
            )
        }.padding(.horizontal)
    }

    private func categoryBreakdown(result: StressTestResult) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detailed Breakdown", comment: "Category breakdown title").font(.headline).padding(.horizontal)
            ForEach(StressCategory.allCases, id: \.self) { category in
                if let score = result.categoryScoresEnum[category] {
                    CategoryScoreView(category: category, score: score, maxScore: 12)
                }
            }
        }
    }

    private func recommendationsSection(result: StressTestResult) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommendations", comment: "Recommendations section title").font(.headline).padding(.horizontal)
            VStack(spacing: 12) {
                ForEach(result.recommendations, id: \.self) { recommendation in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "lightbulb.fill").foregroundColor(.yellow).font(.subheadline)
                        Text(recommendation).font(.subheadline).fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    .padding()
                    .background(
                        ZStack {
                            if #available(iOS 26.0, *) {
                                RoundedRectangle(cornerRadius: 16).fill(.thinMaterial)
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.2), lineWidth: 1))
                            } else {
                                RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground))
                            }
                        }
                    )
                }
            }.padding(.horizontal)
        }
    }
    
    private func saveButton(result: StressTestResult) -> some View {
        Button(action: { saveStressRecord(result: result) }) {
            Text("Save Stress Record", comment: "Button to save stress test result")
                .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding()
                .background(
                    ZStack {
                        if #available(iOS 26.0, *) {
                            Color("AccentColor").opacity(0.8).background(.regularMaterial)
                        } else {
                            Color("AccentColor")
                        }
                    }
                )
                .cornerRadius(12)
        }.padding(.horizontal).padding(.top, 20)
    }
    
    private func saveStressRecord(result: StressTestResult) {
        let sortedCategories = result.categoryScoresEnum.sorted { $0.value > $1.value }
        var triggers: [StressTrigger] = []
        
        for (category, score) in sortedCategories.prefix(2) where score > 2 {
            switch category {
            case .physical: triggers.append(.health)
            case .emotional: triggers.append(.other)
            case .behavioral: triggers.append(.environment)
            case .cognitive: triggers.append(.other)
            }
        }
        if triggers.isEmpty { triggers = [.other] }
        
        let stress = Stress(level: result.stressLevel, triggers: triggers, note: String(localized: "Generated from stress assessment test", comment: "Note for test-generated stress record"))
        dataManager.addStressRecord(stress)
        
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        dismiss()
    }
}

// MARK: - Supporting Views

struct InfoCard: View {
    let icon: String
    let title: LocalizedStringKey
    let description: LocalizedStringKey
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon).font(.title2).foregroundColor(Color("AccentColor")).frame(width: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline).fontWeight(.medium)
                Text(description).font(.caption).foregroundColor(.secondary).fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding()
        .background(
            ZStack {
                if #available(iOS 26.0, *) {
                    RoundedRectangle(cornerRadius: 16).fill(.thinMaterial)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.2), lineWidth: 1))
                } else {
                    RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground))
                }
            }
        )
    }
}

struct OptionButton: View {
    let option: StressTestOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        }) {
            HStack {
                Text(option.text).font(.body).foregroundColor(isSelected ? .white : .primary).multilineTextAlignment(.leading)
                Spacer()
                if isSelected { Image(systemName: "checkmark.circle.fill").foregroundColor(.white) }
            }
            .padding()
            .background(
                ZStack {
                    if #available(iOS 26.0, *) {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 12).fill(Color("AccentColor").opacity(0.8))
                                .background(.regularMaterial).clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.5), lineWidth: 1.5))
                        } else {
                            RoundedRectangle(cornerRadius: 12).fill(.thinMaterial)
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 12).fill(isSelected ? Color("AccentColor") : Color(UIColor.secondarySystemBackground))
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategoryScoreView: View {
    let category: StressCategory
    let score: Int
    let maxScore: Int
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: category.icon).foregroundColor(category.color)
                Text(category.localizedName).font(.subheadline).fontWeight(.medium)
                Spacer()
                Text("\(score)/\(maxScore)").font(.subheadline).fontWeight(.medium).foregroundColor(category.color)
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.2)).frame(height: 8)
                    RoundedRectangle(cornerRadius: 4).fill(category.color)
                        .frame(width: geometry.size.width * (Double(score) / Double(maxScore)), height: 8)
                }
            }.frame(height: 8)
        }
        .padding()
        .background(
            ZStack {
                if #available(iOS 26.0, *) {
                    RoundedRectangle(cornerRadius: 16).fill(.thinMaterial)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.2), lineWidth: 1))
                } else {
                    RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground))
                }
            }
        )
        .padding(.horizontal)
    }
}
