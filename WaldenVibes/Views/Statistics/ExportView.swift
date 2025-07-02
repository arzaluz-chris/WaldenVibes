// WaldenVibes/Views/Statistics/ExportView.swift
import SwiftUI

struct ExportView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "square.and.arrow.up.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color("AccentColor"))
                
                Text("Export Your Data", comment: "Export view title")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Export all your emotions, moments, and stress records to a text file that you can save or share.", comment: "Export view description")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button(action: {
                    showingShareSheet = true
                }) {
                    Label("Export as Text", systemImage: "doc.text")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("AccentColor"))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding(.top, 40)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [dataManager.exportAllData()])
        }
    }
}
