// WaldenVibes/Models/StressTest.swift (CORREGIDO)
import Foundation
import SwiftUI

// MARK: - Stress Test Models
struct StressTestQuestion: Identifiable {
    let id: UUID
    let questionText: LocalizedStringKey
    let options: [StressTestOption]
    let category: StressCategory
    
    init(id: UUID = UUID(), questionText: LocalizedStringKey, options: [StressTestOption], category: StressCategory) {
        self.id = id
        self.questionText = questionText
        self.options = options
        self.category = category
    }
}

struct StressTestOption: Identifiable {
    let id: UUID
    let text: LocalizedStringKey
    let value: Int // 0-3 scale (0 = never, 3 = always)
    
    init(id: UUID = UUID(), text: LocalizedStringKey, value: Int) {
        self.id = id
        self.text = text
        self.value = value
    }
}

enum StressCategory: String, CaseIterable, Codable {
    case physical = "physical"
    case emotional = "emotional"
    case behavioral = "behavioral"
    case cognitive = "cognitive"
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .physical: return LocalizedStringKey("Physical Symptoms")
        case .emotional: return LocalizedStringKey("Emotional State")
        case .behavioral: return LocalizedStringKey("Behavior Changes")
        case .cognitive: return LocalizedStringKey("Thinking Patterns")
        }
    }
    
    var icon: String {
        switch self {
        case .physical: return "heart.fill"
        case .emotional: return "face.smiling"
        case .behavioral: return "person.fill"
        case .cognitive: return "brain.head.profile"
        }
    }
    
    var color: Color {
        switch self {
        case .physical: return .red
        case .emotional: return .blue
        case .behavioral: return .orange
        case .cognitive: return .purple
        }
    }
}

struct StressTestResult: Identifiable, Codable {
    let id: UUID
    let totalScore: Int
    let maxScore: Int
    let stressLevel: Double // 0-10 scale
    let categoryScores: [String: Int] // Changed from [StressCategory: Int] to make it Codable
    let date: Date
    let recommendations: [String]
    
    init(id: UUID = UUID(), totalScore: Int, maxScore: Int, categoryScores: [StressCategory: Int], date: Date = Date()) {
        self.id = id
        self.totalScore = totalScore
        self.maxScore = maxScore
        self.stressLevel = (Double(totalScore) / Double(maxScore)) * 10.0
        
        // Convert StressCategory keys to String for Codable compliance
        var stringCategoryScores: [String: Int] = [:]
        for (category, score) in categoryScores {
            stringCategoryScores[category.rawValue] = score
        }
        self.categoryScores = stringCategoryScores
        
        self.date = date
        self.recommendations = StressTestResult.generateRecommendations(for: stressLevel, categoryScores: categoryScores)
    }
    
    // Helper computed property to get category scores as StressCategory enum
    var categoryScoresEnum: [StressCategory: Int] {
        var result: [StressCategory: Int] = [:]
        for (key, value) in categoryScores {
            if let category = StressCategory(rawValue: key) {
                result[category] = value
            }
        }
        return result
    }
    
    var stressDescription: LocalizedStringKey {
        switch stressLevel {
        case 0..<2: return LocalizedStringKey("Very Low Stress")
        case 2..<4: return LocalizedStringKey("Low Stress")
        case 4..<6: return LocalizedStringKey("Moderate Stress")
        case 6..<8: return LocalizedStringKey("High Stress")
        case 8...10: return LocalizedStringKey("Very High Stress")
        default: return LocalizedStringKey("Unknown")
        }
    }
    
    var stressColor: Color {
        switch stressLevel {
        case 0..<3: return Color("StressLow")
        case 3..<5: return Color("StressModerate")
        case 5..<7: return Color("StressHigh")
        case 7...10: return Color("StressVeryHigh")
        default: return .gray
        }
    }
    
    private static func generateRecommendations(for level: Double, categoryScores: [StressCategory: Int]) -> [String] {
        var recommendations: [String] = []
        
        // General recommendations based on stress level
        if level >= 7 {
            recommendations.append(String(localized: "Consider talking to a counselor or trusted adult", comment: "High stress recommendation"))
            recommendations.append(String(localized: "Practice deep breathing exercises daily", comment: "High stress recommendation"))
        } else if level >= 5 {
            recommendations.append(String(localized: "Try to get more sleep and rest", comment: "Moderate stress recommendation"))
            recommendations.append(String(localized: "Engage in physical activities you enjoy", comment: "Moderate stress recommendation"))
        } else if level >= 3 {
            recommendations.append(String(localized: "Maintain your current healthy habits", comment: "Low stress recommendation"))
        } else {
            recommendations.append(String(localized: "Great job managing your stress! Keep it up", comment: "Very low stress recommendation"))
        }
        
        // Category-specific recommendations
        let maxCategoryScore = categoryScores.values.max() ?? 0
        let problematicCategories = categoryScores.filter { $0.value >= maxCategoryScore - 1 && $0.value > 2 }
        
        for (category, _) in problematicCategories {
            switch category {
            case .physical:
                recommendations.append(String(localized: "Focus on physical relaxation techniques", comment: "Physical stress recommendation"))
            case .emotional:
                recommendations.append(String(localized: "Practice mindfulness and emotional regulation", comment: "Emotional stress recommendation"))
            case .behavioral:
                recommendations.append(String(localized: "Try to maintain healthy routines", comment: "Behavioral stress recommendation"))
            case .cognitive:
                recommendations.append(String(localized: "Challenge negative thought patterns", comment: "Cognitive stress recommendation"))
            }
        }
        
        return recommendations
    }
}

// MARK: - Stress Test Manager
class StressTestManager: ObservableObject {
    static let shared = StressTestManager()
    
    @Published var questions: [StressTestQuestion] = []
    @Published var currentQuestionIndex = 0
    @Published var answers: [UUID: Int] = [:]
    @Published var isTestComplete = false
    @Published var testResult: StressTestResult?
    
    private init() {
        loadQuestions()
    }
    
    private func loadQuestions() {
        questions = [
            // Physical Category
            StressTestQuestion(
                questionText: LocalizedStringKey("How often do you feel tired or exhausted?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("Never"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Sometimes"), value: 1),
                    StressTestOption(text: LocalizedStringKey("Often"), value: 2),
                    StressTestOption(text: LocalizedStringKey("Always"), value: 3)
                ],
                category: .physical
            ),
            StressTestQuestion(
                questionText: LocalizedStringKey("Do you experience headaches or muscle tension?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("Never"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Rarely"), value: 1),
                    StressTestOption(text: LocalizedStringKey("Sometimes"), value: 2),
                    StressTestOption(text: LocalizedStringKey("Frequently"), value: 3)
                ],
                category: .physical
            ),
            StressTestQuestion(
                questionText: LocalizedStringKey("How is your appetite lately?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("Normal and healthy"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Slightly changed"), value: 1),
                    StressTestOption(text: LocalizedStringKey("Eating more or less than usual"), value: 2),
                    StressTestOption(text: LocalizedStringKey("Significant changes in eating"), value: 3)
                ],
                category: .physical
            ),
            StressTestQuestion(
                questionText: LocalizedStringKey("How well are you sleeping?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("Sleeping well"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Some difficulty sleeping"), value: 1),
                    StressTestOption(text: LocalizedStringKey("Often have trouble sleeping"), value: 2),
                    StressTestOption(text: LocalizedStringKey("Very poor sleep"), value: 3)
                ],
                category: .physical
            ),
            
            // Emotional Category
            StressTestQuestion(
                questionText: LocalizedStringKey("How often do you feel worried or anxious?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("Rarely"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Sometimes"), value: 1),
                    StressTestOption(text: LocalizedStringKey("Often"), value: 2),
                    StressTestOption(text: LocalizedStringKey("Most of the time"), value: 3)
                ],
                category: .emotional
            ),
            StressTestQuestion(
                questionText: LocalizedStringKey("Do you feel sad or down?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("No, I feel good"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Occasionally"), value: 1),
                    StressTestOption(text: LocalizedStringKey("Quite often"), value: 2),
                    StressTestOption(text: LocalizedStringKey("Most days"), value: 3)
                ],
                category: .emotional
            ),
            StressTestQuestion(
                questionText: LocalizedStringKey("How easily do you get irritated or angry?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("I'm usually calm"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Sometimes I get irritated"), value: 1),
                    StressTestOption(text: LocalizedStringKey("I get angry quite easily"), value: 2),
                    StressTestOption(text: LocalizedStringKey("I'm often irritated or angry"), value: 3)
                ],
                category: .emotional
            ),
            StressTestQuestion(
                questionText: LocalizedStringKey("Do you feel overwhelmed by daily tasks?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("No, I manage well"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Sometimes it's a lot"), value: 1),
                    StressTestOption(text: LocalizedStringKey("Often feel overwhelmed"), value: 2),
                    StressTestOption(text: LocalizedStringKey("Almost always overwhelmed"), value: 3)
                ],
                category: .emotional
            ),
            
            // Behavioral Category
            StressTestQuestion(
                questionText: LocalizedStringKey("How often do you avoid activities you used to enjoy?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("Never, I do what I like"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Occasionally"), value: 1),
                    StressTestOption(text: LocalizedStringKey("Often"), value: 2),
                    StressTestOption(text: LocalizedStringKey("Most of the time"), value: 3)
                ],
                category: .behavioral
            ),
            StressTestQuestion(
                questionText: LocalizedStringKey("Do you have trouble concentrating on schoolwork or activities?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("No, I concentrate well"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Sometimes it's hard"), value: 1),
                    StressTestOption(text: LocalizedStringKey("Often have trouble"), value: 2),
                    StressTestOption(text: LocalizedStringKey("Very difficult to concentrate"), value: 3)
                ],
                category: .behavioral
            ),
            StressTestQuestion(
                questionText: LocalizedStringKey("Are you avoiding friends or social activities?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("No, I'm social as usual"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Sometimes I prefer to be alone"), value: 1),
                    StressTestOption(text: LocalizedStringKey("Often avoid social activities"), value: 2),
                    StressTestOption(text: LocalizedStringKey("I usually isolate myself"), value: 3)
                ],
                category: .behavioral
            ),
            
            // Cognitive Category
            StressTestQuestion(
                questionText: LocalizedStringKey("How often do you have negative thoughts about yourself?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("Rarely, I think positively"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Sometimes"), value: 1),
                    StressTestOption(text: LocalizedStringKey("Often"), value: 2),
                    StressTestOption(text: LocalizedStringKey("Most of the time"), value: 3)
                ],
                category: .cognitive
            ),
            StressTestQuestion(
                questionText: LocalizedStringKey("Do you worry about things that might happen in the future?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("No, I live in the present"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Sometimes I worry"), value: 1),
                    StressTestOption(text: LocalizedStringKey("I worry quite a bit"), value: 2),
                    StressTestOption(text: LocalizedStringKey("I constantly worry about the future"), value: 3)
                ],
                category: .cognitive
            ),
            StressTestQuestion(
                questionText: LocalizedStringKey("How difficult is it for you to make decisions?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("I decide easily"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Sometimes it takes time"), value: 1),
                    StressTestOption(text: LocalizedStringKey("It's often difficult"), value: 2),
                    StressTestOption(text: LocalizedStringKey("Very hard to make decisions"), value: 3)
                ],
                category: .cognitive
            ),
            StressTestQuestion(
                questionText: LocalizedStringKey("Do you feel like you can't control what happens to you?"),
                options: [
                    StressTestOption(text: LocalizedStringKey("I feel in control"), value: 0),
                    StressTestOption(text: LocalizedStringKey("Sometimes feel out of control"), value: 1),
                    StressTestOption(text: LocalizedStringKey("Often feel helpless"), value: 2),
                    StressTestOption(text: LocalizedStringKey("Almost always feel powerless"), value: 3)
                ],
                category: .cognitive
            )
        ]
    }
    
    func startTest() {
        currentQuestionIndex = 0
        answers.removeAll()
        isTestComplete = false
        testResult = nil
    }
    
    func answerQuestion(questionId: UUID, value: Int) {
        answers[questionId] = value
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            completeTest()
        }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    func canProceed() -> Bool {
        guard currentQuestionIndex < questions.count else { return false }
        let currentQuestion = questions[currentQuestionIndex]
        return answers[currentQuestion.id] != nil
    }
    
    private func completeTest() {
        let totalScore = answers.values.reduce(0, +)
        let maxScore = questions.count * 3 // Maximum possible score
        
        // Calculate category scores
        var categoryScores: [StressCategory: Int] = [:]
        for category in StressCategory.allCases {
            let categoryQuestions = questions.filter { $0.category == category }
            let categoryScore = categoryQuestions.compactMap { answers[$0.id] }.reduce(0, +)
            categoryScores[category] = categoryScore
        }
        
        testResult = StressTestResult(
            totalScore: totalScore,
            maxScore: maxScore,
            categoryScores: categoryScores
        )
        
        isTestComplete = true
    }
    
    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex + 1) / Double(questions.count)
    }
    
    var currentQuestion: StressTestQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var selectedAnswer: Int? {
        guard let question = currentQuestion else { return nil }
        return answers[question.id]
    }
}
