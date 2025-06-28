//  EmotionDetailView.swift
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
                            Label("intensity.label", systemImage: "dial.high")
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
                                Label("notes.label", systemImage: "note.text")
                                    .font(.headline)
                                
                                Text(emotion.note)
                                    .font(.body)
                            }
                            
                            Divider()
                        }
                        
                        // Location
                        if let location = emotion.location {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("location.label", systemImage: "location.fill")
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
                    Button("done") {
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
            .alert("delete.confirm.title", isPresented: $showingDeleteAlert) {
                Button("delete", role: .destructive) {
                    dataManager.deleteEmotion(emotion)
                    dismiss()
                }
                Button("cancel", role: .cancel) {}
            } message: {
                Text("delete.confirm.message")
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditEmotionView(emotion: emotion)
        }
    }
}
