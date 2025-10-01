// WaldenVibes/Views/Stress/StressTipsView.swift
import SwiftUI

struct StressTipsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            NavigationView {
                List(StressTip.tips) { tip in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: tip.icon)
                                .font(.title2)
                                .foregroundColor(Color("AccentColor"))
                                .frame(width: 40)
                            
                            Text(tip.title)
                                .font(.headline)
                        }
                        
                        Text(tip.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear.background(.thinMaterial))
                }
                .scrollContentBackground(.hidden)
                .background(AnimatedGlassBackground(color: Color("AccentColor")))
                .navigationTitle("Stress Relief Tips")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
            }
        } else {
            // MARK: - iOS 18 Design
            NavigationView {
                List(StressTip.tips) { tip in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: tip.icon)
                                .font(.title2)
                                .foregroundColor(Color("AccentColor"))
                                .frame(width: 40)
                            
                            Text(tip.title)
                                .font(.headline)
                        }
                        
                        Text(tip.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 8)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Stress Relief Tips")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
            }
        }
    }
}
