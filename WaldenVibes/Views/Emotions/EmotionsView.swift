// EmotionsView.swift - Fixed
import SwiftUI

struct EmotionsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddEmotion = false
    @State private var selectedEmotion: Emotion?
    @State private var selectedFilter: EmotionType? = nil
    
    var filteredEmotions: [Emotion] {
        if let filter = selectedFilter {
            return dataManager.emotions.filter { $0.type == filter }
        }
        return dataManager.emotions
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color("AccentColor").opacity(0.05),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
            
            if dataManager.emotions.isEmpty {
                // Empty state
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
            } else {
                VStack(spacing: 0) {
                    // Filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            FilterChip(
                                title: "All",
                                isSelected: selectedFilter == nil,
                                color: Color("AccentColor")
                            ) {
                                selectedFilter = nil
                            }
                            
                            ForEach(EmotionType.allCases, id: \.self) { type in
                                FilterChip(
                                    title: type.emoji,
                                    isSelected: selectedFilter == type,
                                    color: type.color
                                ) {
                                    selectedFilter = type
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    }
                    
                    Divider()
                    
                    // Emotions List
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
    
    private var groupedEmotions: [(key: Date, value: [Emotion])] {
        let grouped = Dictionary(grouping: filteredEmotions) { emotion in
            Calendar.current.startOfDay(for: emotion.date)
        }
        return grouped.sorted { $0.key > $1.key }
    }
}
