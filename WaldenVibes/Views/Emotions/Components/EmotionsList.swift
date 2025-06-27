// EmotionsList.swift
import SwiftUI

struct EmotionsList: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedEmotion: Emotion?
    let filter: EmotionType?
    
    var filteredEmotions: [Emotion] {
        if let filter = filter {
            return dataManager.emotions.filter { $0.type == filter }
        }
        return dataManager.emotions
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(groupedEmotions, id: \.key) { date, emotions in
                    Section {
                        ForEach(emotions) { emotion in
                            EmotionCard(emotion: emotion)
                                .onTapGesture {
                                    selectedEmotion = emotion
                                }
                        }
                    } header: {
                        HStack {
                            Text(date, style: .date)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, date == groupedEmotions.first?.key ? 0 : 10)
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    private var groupedEmotions: [(key: Date, value: [Emotion])] {
        let grouped = Dictionary(grouping: filteredEmotions) { emotion in
            Calendar.current.startOfDay(for: emotion.date)
        }
        return grouped.sorted { $0.key > $1.key }
    }
}
