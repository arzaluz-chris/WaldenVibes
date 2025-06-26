//  MomentsView.swift
import SwiftUI

struct MomentsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddMoment = false
    @State private var selectedCategory: MomentCategory? = nil
    
    var body: some View {
        ZStack {
            if dataManager.moments.isEmpty {
                EmptyMomentsView(showingAddMoment: $showingAddMoment)
            } else {
                MomentsList(selectedCategory: $selectedCategory)
            }
        }
        .navigationTitle("nav.moments")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddMoment = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color("AccentColor"))
                }
            }
        }
        .sheet(isPresented: $showingAddMoment) {
            AddMomentView()
        }
    }
}

// MARK: - Empty State
struct EmptyMomentsView: View {
    @Binding var showingAddMoment: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image("EmptyMoments")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .opacity(0.5)
            
            Text("moments.empty.title")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("moments.empty.subtitle")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: { showingAddMoment = true }) {
                Label("moments.add", systemImage: "plus.circle.fill")
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

// MARK: - Moments List
struct MomentsList: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedCategory: MomentCategory?
    
    var filteredMoments: [Moment] {
        if let category = selectedCategory {
            return dataManager.moments.filter { $0.category == category }
        }
        return dataManager.moments
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    CategoryChip(
                        title: "category.all",
                        icon: "square.grid.2x2",
                        color: Color("AccentColor"),
                        isSelected: selectedCategory == nil,
                        action: { selectedCategory = nil }
                    )
                    
                    ForEach(MomentCategory.allCases, id: \.self) { category in
                        CategoryChip(
                            title: category.localizedName,
                            icon: category.icon,
                            color: category.color,
                            isSelected: selectedCategory == category,
                            action: { selectedCategory = category }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .background(Color(UIColor.systemBackground))
            
            Divider()
            
            // Moments List
            if filteredMoments.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("moments.filter.empty")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(groupedMoments, id: \.key) { date, moments in
                            Section {
                                ForEach(moments) { moment in
                                    MomentCard(moment: moment)
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
                                .padding(.top, date == groupedMoments.first?.key ? 0 : 10)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
    
    private var groupedMoments: [(key: Date, value: [Moment])] {
        let grouped = Dictionary(grouping: filteredMoments) { moment in
            Calendar.current.startOfDay(for: moment.date)
        }
        return grouped.sorted { $0.key > $1.key }
    }
}
