// WaldenVibes/Views/Stress/StressDetailView.swift
import SwiftUI

struct StressDetailView: View {
    let stress: Stress
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header with level
                    VStack(spacing: 16) {
                        Text(stress.stressEmoji)
                            .font(.system(size: 80))
                        
                        Text(stress.stressDescription)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Text("Level:", comment: "Stress level label")
                                .foregroundColor(.secondary)
                            Text("\(Int(stress.level))/10")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(stress.stressColor)
                        }
                        
                        Text(stress.date.formatted(date: .complete, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    
                    // Visual stress meter
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Stress Level", systemImage: "waveform.path.ecg")
                            .font(.headline)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 40)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(stress.stressColor)
                                    .frame(width: geometry.size.width * (stress.level / 10), height: 40)
                            }
                        }
                        .frame(height: 40)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Triggers
                    if !stress.triggers.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Stress Triggers", systemImage: "exclamationmark.triangle.fill")
                                .font(.headline)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(stress.triggers, id: \.self) { trigger in
                                    HStack(spacing: 6) {
                                        Image(systemName: trigger.icon)
                                        Text(trigger.localizedName)
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color("AccentColor").opacity(0.1))
                                    .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                    }
                    
                    // Note
                    if !stress.note.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Notes", systemImage: "note.text")
                                .font(.headline)
                            
                            Text(stress.note)
                                .font(.body)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .alert("Delete Stress Record?", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    dataManager.deleteStressRecord(stress)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this stress record?")
            }
        }
    }
}
