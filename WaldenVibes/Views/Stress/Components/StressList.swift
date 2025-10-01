// WaldenVibes/Views/Stress/Components/StressList.swift
import SwiftUI

struct StressList: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedStress: Stress?
    @Binding var showingTips: Bool
    @Binding var showingStressTest: Bool
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            ScrollView {
                VStack(spacing: 24) {
                    if let latestStress = dataManager.stressRecords.first {
                        CurrentStressCard(stress: latestStress)
                            .padding(.horizontal)
                            .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity)
                            .padding(.top)
                    }
                    
                    quickActions
                        .padding(.horizontal)
                        .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity)
                    
                    historySection
                }
                .padding(.bottom)
            }
        } else {
            // MARK: - iOS 18 Design
            ScrollView {
                VStack(spacing: 20) {
                    if let latestStress = dataManager.stressRecords.first {
                        CurrentStressCard(stress: latestStress)
                            .padding(.horizontal)
                            .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity)
                            .padding(.top)
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: { showingTips = true }) {
                            HStack {
                                Image(systemName: "lightbulb.fill").font(.title3)
                                VStack(alignment: .leading) {
                                    Text("Stress Relief Tips", comment: "Title for stress relief tips button").font(.headline)
                                    Text("Tap for quick tips", comment: "Subtitle for stress relief tips button").font(.caption).foregroundColor(.secondary)
                                }
                                Spacer()
                            }.padding().background(RoundedRectangle(cornerRadius: 16).fill(Color("AccentColor").opacity(0.1)))
                        }.buttonStyle(PlainButtonStyle())
                        
                        Button(action: { showingStressTest = true }) {
                            HStack {
                                Image(systemName: "doc.text.magnifyingglass").font(.title3)
                                VStack(alignment: .leading) {
                                    Text("Quick Test", comment: "Title for stress test button").font(.headline)
                                    Text("Assess stress level", comment: "Subtitle for stress test button").font(.caption).foregroundColor(.secondary)
                                }
                                Spacer()
                            }.padding().background(RoundedRectangle(cornerRadius: 16).fill(Color("StressModerate").opacity(0.1)))
                        }.buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Stress History", comment: "Section header for stress history").font(.headline).padding(.horizontal)
                            .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity, alignment: .leading)
                        
                        if horizontalSizeClass == .regular {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(dataManager.stressRecords) { stress in StressCard(stress: stress).onTapGesture { selectedStress = stress } }
                            }.padding(.horizontal).frame(maxWidth: 1000)
                        } else {
                            ForEach(dataManager.stressRecords) { stress in StressCard(stress: stress).onTapGesture { selectedStress = stress } }
                        }
                    }
                }
                .padding(.bottom)
            }
        }
    }

    @available(iOS 26.0, *)
    private var quickActions: some View {
        HStack(spacing: 16) {
            Button(action: { showingTips = true }) {
                quickActionButtonContent(
                    icon: "lightbulb.fill",
                    title: "Stress Relief Tips",
                    subtitle: "Tap for quick tips",
                    color: Color("AccentColor")
                )
            }.buttonStyle(PlainButtonStyle())
            
            Button(action: { showingStressTest = true }) {
                quickActionButtonContent(
                    icon: "doc.text.magnifyingglass",
                    title: "Quick Test",
                    subtitle: "Assess stress level",
                    color: Color("StressModerate")
                )
            }.buttonStyle(PlainButtonStyle())
        }
    }

    @available(iOS 26.0, *)
    private func quickActionButtonContent(icon: String, title: LocalizedStringKey, subtitle: LocalizedStringKey, color: Color) -> some View {
        HStack {
            Image(systemName: icon).font(.title3)
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(subtitle).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(color.opacity(0.1))
        .background(.thinMaterial)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.2), lineWidth: 1))
    }

    @available(iOS 26.0, *)
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Stress History", comment: "Section header for stress history")
                .font(.headline)
                .padding(.horizontal)
                .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity, alignment: .leading)
            
            if horizontalSizeClass == .regular {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(dataManager.stressRecords) { stress in
                        StressCard(stress: stress).onTapGesture { selectedStress = stress }
                    }
                }.padding(.horizontal).frame(maxWidth: 1000)
            } else {
                ForEach(dataManager.stressRecords) { stress in
                    StressCard(stress: stress).onTapGesture { selectedStress = stress }
                }
            }
        }
    }
}
