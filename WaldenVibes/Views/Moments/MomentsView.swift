// WaldenVibes/Views/Moments/MomentsView.swift
import SwiftUI

struct MomentsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddMoment = false
    @State private var selectedCategory: MomentCategory? = nil
    @State private var selectedMoment: Moment?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            ZStack {
                // Animated star background
                AnimatedGlassBackground(color: selectedCategory?.color ?? Color("AccentColor"))
                    .overlay(
                        ForEach(0..<20, id: \.self) { _ in
                            SparkleView()
                        }
                    )
                
                if dataManager.moments.isEmpty {
                    EmptyMomentsView(showingAddMoment: $showingAddMoment)
                        .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)
                } else {
                    MomentsList(selectedCategory: $selectedCategory, selectedMoment: $selectedMoment)
                }
            }
            .navigationTitle("Moments")
            .toolbar { navigationToolbar }
            .sheet(isPresented: $showingAddMoment) { AddMomentView() }
            .sheet(item: $selectedMoment) { moment in MomentDetailView(moment: moment) }

        } else {
            // MARK: - iOS 18 Design
            ZStack {
                GeometryReader { geometry in
                    ForEach(0..<20, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(Color("AccentColor").opacity(0.03))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                    }
                }
                .ignoresSafeArea()
                
                if dataManager.moments.isEmpty {
                    EmptyMomentsView(showingAddMoment: $showingAddMoment)
                        .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)
                } else {
                    MomentsList(selectedCategory: $selectedCategory, selectedMoment: $selectedMoment)
                }
            }
            .navigationTitle("Moments")
            .navigationBarTitleDisplayMode(horizontalSizeClass == .regular ? .large : .automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddMoment = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color("AccentColor"))
                    }
                }
            }
            .sheet(isPresented: $showingAddMoment) { AddMomentView() }
            .sheet(item: $selectedMoment) { moment in MomentDetailView(moment: moment) }
        }
    }
    
    @ToolbarContentBuilder
    private var navigationToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showingAddMoment = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color("AccentColor"))
            }
        }
    }
}

// MARK: - iOS 26 Specific Sparkle View
@available(iOS 26.0, *)
struct SparkleView: View {
    @State private var isAnimating = false
    let duration = Double.random(in: 3...7)
    let size = CGFloat.random(in: 5...15)

    var body: some View {
        GeometryReader { geometry in
            Image(systemName: "sparkle")
                .font(.system(size: size))
                .foregroundColor(.white.opacity(Double.random(in: 0.3...0.8)))
                .position(
                    x: isAnimating ? CGFloat.random(in: 0...geometry.size.width) : CGFloat.random(in: 0...geometry.size.width),
                    y: isAnimating ? CGFloat.random(in: 0...geometry.size.height) : CGFloat.random(in: 0...geometry.size.height)
                )
                .onAppear {
                    withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
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
           
           Text("No moments yet", comment: "Empty state title when no moments have been recorded")
               .font(.title2)
               .fontWeight(.semibold)
           
           Text("Start capturing your special moments to preserve your memories", comment: "Empty state subtitle encouraging user to start recording moments")
               .font(.body)
               .foregroundColor(.secondary)
               .multilineTextAlignment(.center)
               .padding(.horizontal, 40)
           
           Button(action: { showingAddMoment = true }) {
               Label("Add Moment", systemImage: "plus.circle.fill")
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
    @Binding var selectedMoment: Moment?
    @State private var momentToDelete: Moment?
    @State private var showingDeleteAlert = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
   
    var filteredMoments: [Moment] {
        if let category = selectedCategory {
            return dataManager.moments.filter { $0.category == category }
        }
        return dataManager.moments
    }
   
    var body: some View {
        VStack(spacing: 0) {
            if #available(iOS 26.0, *) {
                categoryFilter
                    .background(.thinMaterial)
            } else {
                categoryFilter
                    .background(Color(UIColor.systemBackground))
                Divider()
            }
            
            listContent
        }
        .alert("Delete Moment?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                if let moment = momentToDelete {
                    withAnimation {
                        dataManager.deleteMoment(moment)
                    }
                }
            }
        } message: {
            Text("Are you sure you want to delete this special moment?")
        }
    }
   
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    title: String(localized: "All", comment: "Filter option to show all categories"),
                    icon: "square.grid.2x2",
                    color: Color("AccentColor"),
                    isSelected: selectedCategory == nil,
                    action: { selectedCategory = nil }
                )

                ForEach(MomentCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        title: categoryTitle(for: category),
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
    }
   
    private func categoryTitle(for category: MomentCategory) -> String {
        switch category {
        case .work: return String(localized: "Work")
        case .family: return String(localized: "Family")
        case .friends: return String(localized: "Friends")
        case .personal: return String(localized: "Personal")
        case .general: return String(localized: "General")
        }
    }

    private var listContent: some View {
        Group {
            if filteredMoments.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("No moments in this category", comment: "Message shown when no moments match the selected filter")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            } else {
                ScrollView {
                    if horizontalSizeClass == .regular {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(filteredMoments) { moment in
                                MomentCard(moment: moment)
                                    .onTapGesture { selectedMoment = moment }
                                    .contextMenu { deleteButton(for: moment) }
                            }
                        }
                        .padding()
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(groupedMoments, id: \.key) { group in
                                MomentSectionView(
                                    date: group.key,
                                    moments: group.value,
                                    isFirst: group.key == firstGroupDate,
                                    selectedMoment: $selectedMoment,
                                    momentToDelete: $momentToDelete,
                                    showingDeleteAlert: $showingDeleteAlert
                                )
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
    }
    
    private func deleteButton(for moment: Moment) -> some View {
        Button(role: .destructive) {
            momentToDelete = moment
            showingDeleteAlert = true
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    private var groupedMoments: [(key: Date, value: [Moment])] {
        let grouped = Dictionary(grouping: filteredMoments) { moment in
            Calendar.current.startOfDay(for: moment.date)
        }
        return grouped.sorted { $0.key > $1.key }
    }
    
    private var firstGroupDate: Date? {
        groupedMoments.first?.key
    }
}

private struct MomentSectionView: View {
    let date: Date
    let moments: [Moment]
    let isFirst: Bool
    
    @Binding var selectedMoment: Moment?
    @Binding var momentToDelete: Moment?
    @Binding var showingDeleteAlert: Bool
   
    var body: some View {
        Section {
            ForEach(moments) { moment in
                MomentCard(moment: moment)
                    .onTapGesture { selectedMoment = moment }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            momentToDelete = moment
                            showingDeleteAlert = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        } header: {
            HStack {
                Text(date, style: .date)
                    .font(.subheadline).fontWeight(.medium).foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, isFirst ? 0 : 10)
        }
    }
}
