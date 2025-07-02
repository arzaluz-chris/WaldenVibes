// WaldenVibes/Views/Emotions/EmotionDetailView.swift
import SwiftUI

struct EmotionDetailView: View {
    let emotion: Emotion
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var showingDeleteAlert = false
    @State private var showingEditView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Text(emotion.type.emoji)
                            .font(.system(size: 80))
                        
                        Text(emotion.type.localizedName)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(emotion.date.formatted(date: .complete, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(emotion.type.gradient.opacity(0.3))
                    
                    // Details
                    VStack(alignment: .leading, spacing: 20) {
                        // Intensity
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Intensity", systemImage: "dial.high")
                                .font(.headline)
                            
                            HStack {
                                IntensityView(intensity: emotion.intensity, color: emotion.type.color)
                                Spacer()
                                Text("\(Int(emotion.intensity))/10")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(emotion.type.color)
                            }
                        }
                        
                        Divider()
                        
                        // Note
                        if !emotion.note.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Notes", systemImage: "note.text")
                                    .font(.headline)
                                
                                Text(emotion.note)
                                    .font(.body)
                            }
                            
                            Divider()
                        }
                        
                        // Location
                        if let location = emotion.location {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Location", systemImage: "location.fill")
                                    .font(.headline)
                                
                                Text(location)
                                    .font(.body)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: { showingEditView = true }) {
                            Image(systemName: "pencil")
                                .foregroundColor(Color("AccentColor"))
                        }
                        
                        Button(action: { showingDeleteAlert = true }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .alert("Delete Emotion?", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    dataManager.deleteEmotion(emotion)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this emotion record?")
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditEmotionView(emotion: emotion)
        }
    }
}
