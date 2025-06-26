//  EmotionsView.swift
import SwiftUI

struct EmotionsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddEmotion = false
    @State private var selectedEmotion: Emotion?
    
    var body: some View {
        ZStack {
            if dataManager.emotions.isEmpty {
                EmptyEmotionsView(showingAddEmotion: $showingAddEmotion)
            } else {
                EmotionsList(selectedEmotion: $selectedEmotion)
            }
        }
        .navigationTitle("nav.emotions")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddEmotion = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color("AccentColor"))
                }
            }
        }
        .sheet(isPresented: $showingAddEmotion) {
            AddEmotionView()
        }
        .sheet(item: $selectedEmotion) { emotion in
            EmotionDetailView(emotion: emotion)
        }
    }
}

// MARK: - Empty State
struct EmptyEmotionsView: View {
    @Binding var showingAddEmotion: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image("EmptyEmotions")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .opacity(0.5)
            
            Text("emotions.empty.title")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("emotions.empty.subtitle")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: { showingAddEmotion = true }) {
                Label("emotions.add", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color("AccentColor"))
                    .cornerRadius(25)
            }
            .padding(.top, 10)
        }
    }
}

// MARK: - Emotions List
struct EmotionsList: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedEmotion: Emotion?
    
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
        let grouped = Dictionary(grouping: dataManager.emotions) { emotion in
            Calendar.current.startOfDay(for: emotion.date)
        }
        return grouped.sorted { $0.key > $1.key }
    }
}
