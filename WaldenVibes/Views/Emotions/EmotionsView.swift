// WaldenVibes/Views/Emotions/EmotionsView.swift
import SwiftUI

struct EmotionsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddEmotion = false
    @State private var selectedEmotion: Emotion?
    @State private var selectedFilter: EmotionType? = nil
    @State private var emotionToDelete: Emotion?
    @State private var showingDeleteAlert = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
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
                    
                    Text("No emotions recorded", comment: "Empty state title when no emotions have been tracked")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Start tracking how you feel to monitor your emotional well-being", comment: "Empty state subtitle encouraging user to start tracking emotions")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        // Add haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        showingAddEmotion = true
                    }) {
                        Label("Add Emotion", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color("AccentColor"))
                            .cornerRadius(25)
                    }
                    .padding(.top, 10)
                }
                .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)
            } else {
                VStack(spacing: 0) {
                    // Filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            FilterChip(
                                title: String(localized: "All", comment: "Filter option to show all emotions"),
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
                                            .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity)
                                            .onTapGesture {
                                                selectedEmotion = emotion
                                            }
                                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                                Button(role: .destructive) {
                                                    emotionToDelete = emotion
                                                    showingDeleteAlert = true
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
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
                                    .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity)
                                    .padding(.top, date == groupedEmotions.first?.key ? 0 : 10)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
        .navigationTitle("Emotions")
        .navigationBarTitleDisplayMode(horizontalSizeClass == .regular ? .large : .automatic)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Add haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    showingAddEmotion = true
                }) {
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
        .alert("Delete Emotion?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let emotion = emotionToDelete {
                    withAnimation {
                        dataManager.deleteEmotion(emotion)
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this emotion record?")
        }
    }
    
    private var groupedEmotions: [(key: Date, value: [Emotion])] {
        let grouped = Dictionary(grouping: filteredEmotions) { emotion in
            Calendar.current.startOfDay(for: emotion.date)
        }
        return grouped.sorted { $0.key > $1.key }
    }
}
