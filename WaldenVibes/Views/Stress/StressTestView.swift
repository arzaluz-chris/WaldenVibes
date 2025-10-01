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
                    // Animated glass background
                    AnimatedGlassBackground(color: Color("AccentColor"))

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
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }

                    if !showingIntroduction && !testManager.isTestComplete {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Text("\(testManager.currentQuestionIndex + 1)/\(testManager.questions.count)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .navigationTitle("Stress Assessment")
            }
        } else {
            // MARK: - iOS 18 Design
            NavigationView {
                ZStack {
                    // Background gradient
                    LinearGradient(
                        colors: [
                            Color("AccentColor").opacity(0.1),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .center
                    )
                    .ignoresSafeArea()

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
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }

                    if !showingIntroduction && !testManager.isTestComplete {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Text("\(testManager.currentQuestionIndex + 1)/\(testManager.questions.count)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .navigationTitle("Stress Assessment")
                .toolbarBackground(Color(.systemBackground), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
    
    // MARK: - Introduction View
    private var introductionView: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color("AccentColor"))

                        Text("Stress Level Assessment", comment: "Stress test introduction title")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)

                        Text("This quick assessment will help us understand your current stress level more accurately.", comment: "Stress test introduction description")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 40)

                    // Information cards
                    VStack(spacing: 16) {
                        InfoCard(
                            icon: "clock.fill",
                            title: LocalizedStringKey("Quick & Easy"),
                            description: LocalizedStringKey("Takes only 3-5 minutes to complete")
                        )

                        InfoCard(
                            icon: "lock.shield.fill",
                            title: LocalizedStringKey("Private & Secure"),
                            description: LocalizedStringKey("Your answers stay on your device")
                        )

                        InfoCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: LocalizedStringKey("Personalized Results"),
                            description: LocalizedStringKey("Get insights and recommendations based on your responses")
                        )
                    }
                    .padding(.horizontal)

                    // Instructions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How it works:", comment: "Instructions header")
                            .font(.headline)

                        Text("• Answer honestly based on how you've been feeling lately", comment: "Instruction 1")
                        Text("• There are no right or wrong answers", comment: "Instruction 2")
                        Text("• The assessment covers different aspects of stress", comment: "Instruction 3")
                        Text("• You'll get a personalized stress level and tips", comment: "Instruction 4")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(LinearGradient(
                                colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ), lineWidth: 1)
                    )
                    .padding(.horizontal)

                    // Start button
                    Button(action: {
                        withAnimation {
                            showingIntroduction = false
                            testManager.startTest()
                        }
                    }) {
                        Text("Start Assessment", comment: "Button to start stress test")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AccentColor"))
                            .cornerRadius(12)
                            .shadow(color: Color("AccentColor").opacity(0.3), radius: 10, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    Spacer(minLength: 40)
                }
            }
        } else {
            // MARK: - iOS 18 Design
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color("AccentColor"))

                        Text("Stress Level Assessment", comment: "Stress test introduction title")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)

                        Text("This quick assessment will help us understand your current stress level more accurately.", comment: "Stress test introduction description")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 40)

                    // Information cards
                    VStack(spacing: 16) {
                        InfoCard(
                            icon: "clock.fill",
                            title: LocalizedStringKey("Quick & Easy"),
                            description: LocalizedStringKey("Takes only 3-5 minutes to complete")
                        )

                        InfoCard(
                            icon: "lock.shield.fill",
                            title: LocalizedStringKey("Private & Secure"),
                            description: LocalizedStringKey("Your answers stay on your device")
                        )

                        InfoCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: LocalizedStringKey("Personalized Results"),
                            description: LocalizedStringKey("Get insights and recommendations based on your responses")
                        )
                    }
                    .padding(.horizontal)

                    // Instructions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How it works:", comment: "Instructions header")
                            .font(.headline)

                        Text("• Answer honestly based on how you've been feeling lately", comment: "Instruction 1")
                        Text("• There are no right or wrong answers", comment: "Instruction 2")
                        Text("• The assessment covers different aspects of stress", comment: "Instruction 3")
                        Text("• You'll get a personalized stress level and tips", comment: "Instruction 4")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
                    .padding(.horizontal)

                    // Start button
                    Button(action: {
                        withAnimation {
                            showingIntroduction = false
                            testManager.startTest()
                        }
                    }) {
                        Text("Start Assessment", comment: "Button to start stress test")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AccentColor"))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    Spacer(minLength: 40)
                }
            }
        }
    }
    
    // MARK: - Test View
    private var testView: some View {
        VStack(spacing: 0) {
            // Progress bar
            VStack(spacing: 8) {
                ProgressView(value: testManager.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color("AccentColor")))
                    .frame(height: 8)
                    .padding(.horizontal)
                
                HStack {
                    Text("Question \(testManager.currentQuestionIndex + 1) of \(testManager.questions.count)", comment: "Progress indicator")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            .background(Color(UIColor.systemBackground))
            
            ScrollView {
                VStack(spacing: 24) {
                    if let question = testManager.currentQuestion {
                        // Category indicator
                        HStack {
                            Image(systemName: question.category.icon)
                                .foregroundColor(question.category.color)
                            Text(question.category.localizedName)
                                .font(.subheadline)
                                .foregroundColor(question.category.color)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Question
                        VStack(spacing: 20) {
                            Text(question.questionText)
                                .font(.title3)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            // Options
                            VStack(spacing: 12) {
                                ForEach(question.options) { option in
                                    OptionButton(
                                        option: option,
                                        isSelected: testManager.selectedAnswer == option.value,
                                        action: {
                                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                            impactFeedback.impactOccurred()
                                            testManager.answerQuestion(questionId: question.id, value: option.value)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            
            // Navigation buttons
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    if testManager.currentQuestionIndex > 0 {
                        Button(action: {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            testManager.previousQuestion()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Previous", comment: "Previous question button")
                            }
                            .font(.subheadline)
                            .foregroundColor(Color("AccentColor"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("AccentColor"), lineWidth: 1)
                            )
                        }
                    }
                    
                    Button(action: {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        testManager.nextQuestion()
                    }) {
                        HStack {
                            Text(testManager.currentQuestionIndex == testManager.questions.count - 1 ?
                                 LocalizedStringKey("Finish") : LocalizedStringKey("Next"))
                            if testManager.currentQuestionIndex < testManager.questions.count - 1 {
                                Image(systemName: "chevron.right")
                            }
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(testManager.canProceed() ? Color("AccentColor") : Color.gray)
                        )
                    }
                    .disabled(!testManager.canProceed())
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color(UIColor.systemBackground))
        }
    }
    
    // MARK: - Result View
    private var resultView: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let result = testManager.testResult {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text("Assessment Complete", comment: "Test completion title")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Based on your responses, here's your stress assessment:", comment: "Result introduction")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    // Stress level result
                    VStack(spacing: 20) {
                        // Visual stress meter
                        VStack(spacing: 12) {
                            Text("Your Stress Level", comment: "Stress level section title")
                                .font(.headline)
                            
                            ZStack {
                                Circle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                                    .frame(width: 200, height: 200)
                                
                                Circle()
                                    .trim(from: 0, to: result.stressLevel / 10)
                                    .stroke(result.stressColor, lineWidth: 20)
                                    .frame(width: 200, height: 200)
                                    .rotationEffect(.degrees(-90))
                                
                                VStack {
                                    Text(String(format: "%.1f", result.stressLevel))
                                        .font(.system(size: 42, weight: .bold, design: .rounded))
                                        .foregroundColor(result.stressColor)
                                    Text("/ 10")
                                        .font(.title3)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Text(result.stressDescription)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(result.stressColor)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(UIColor.secondarySystemBackground))
                        )
                    }
                    .padding(.horizontal)
                    
                    // Category breakdown
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Detailed Breakdown", comment: "Category breakdown title")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(StressCategory.allCases, id: \.self) { category in
                            if let score = result.categoryScoresEnum[category] {
                                CategoryScoreView(category: category, score: score, maxScore: 12)
                            }
                        }
                    }
                    
                    // Recommendations
                    if !result.recommendations.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recommendations", comment: "Recommendations section title")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ForEach(result.recommendations, id: \.self) { recommendation in
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: "lightbulb.fill")
                                            .foregroundColor(.yellow)
                                            .font(.subheadline)
                                        
                                        Text(recommendation)
                                            .font(.subheadline)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(UIColor.secondarySystemBackground))
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Save button
                    Button(action: {
                        saveStressRecord(result: result)
                    }) {
                        Text("Save Stress Record", comment: "Button to save stress test result")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AccentColor"))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer(minLength: 40)
                }
            }
        }
    }
    
    private func saveStressRecord(result: StressTestResult) {
        // Create main triggers based on highest category scores
        let sortedCategories = result.categoryScoresEnum.sorted { $0.value > $1.value }
        var triggers: [StressTrigger] = []
        
        // Map categories to triggers
        for (category, score) in sortedCategories.prefix(2) where score > 2 {
            switch category {
            case .physical:
                triggers.append(.health)
            case .emotional:
                triggers.append(.other)
            case .behavioral:
                triggers.append(.environment)
            case .cognitive:
                triggers.append(.other)
            }
        }
        
        // If no specific triggers, add general ones
        if triggers.isEmpty {
            triggers = [.other]
        }
        
        let stress = Stress(
            level: result.stressLevel,
            triggers: triggers,
            note: String(localized: "Generated from stress assessment test", comment: "Note for test-generated stress record")
        )
        
        dataManager.addStressRecord(stress)
        
        // Strong haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        dismiss()
    }
}

// MARK: - Supporting Views

struct InfoCard: View {
    let icon: String
    let title: LocalizedStringKey
    let description: LocalizedStringKey

    var body: some View {
        if #available(iOS 26.0, *) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Color("AccentColor"))
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(LinearGradient(
                        colors: [.white.opacity(0.5), .white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ), lineWidth: 1)
            )
        } else {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Color("AccentColor"))
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
        }
    }
}

struct OptionButton: View {
    let option: StressTestOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        if #available(iOS 26.0, *) {
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                action()
            }) {
                HStack {
                    Text(option.text)
                        .font(.body)
                        .foregroundColor(isSelected ? .white : .primary)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(
                    Group {
                        if isSelected {
                            Color("AccentColor")
                                .cornerRadius(12)
                                .shadow(color: Color("AccentColor").opacity(0.3), radius: 10, y: 5)
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.regularMaterial)
                                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(LinearGradient(
                                            colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ), lineWidth: 1)
                                )
                        }
                    }
                )
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                action()
            }) {
                HStack {
                    Text(option.text)
                        .font(.body)
                        .foregroundColor(isSelected ? .white : .primary)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color("AccentColor") : Color(UIColor.secondarySystemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? Color("AccentColor") : Color.clear, lineWidth: 2)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct CategoryScoreView: View {
    let category: StressCategory
    let score: Int
    let maxScore: Int

    var body: some View {
        if #available(iOS 26.0, *) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: category.icon)
                        .foregroundColor(category.color)
                    Text(category.localizedName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(score)/\(maxScore)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(category.color)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(category.color)
                            .frame(width: geometry.size.width * (Double(score) / Double(maxScore)), height: 8)
                            .shadow(color: category.color.opacity(0.5), radius: 4, y: 2)
                    }
                }
                .frame(height: 8)
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(LinearGradient(
                        colors: [.white.opacity(0.5), .white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ), lineWidth: 1)
            )
            .padding(.horizontal)
        } else {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: category.icon)
                        .foregroundColor(category.color)
                    Text(category.localizedName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(score)/\(maxScore)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(category.color)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(category.color)
                            .frame(width: geometry.size.width * (Double(score) / Double(maxScore)), height: 8)
                    }
                }
                .frame(height: 8)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
            .padding(.horizontal)
        }
    }
}

