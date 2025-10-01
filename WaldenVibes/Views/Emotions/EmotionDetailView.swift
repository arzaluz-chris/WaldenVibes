// WaldenVibes/Views/Emotions/EmotionDetailView.swift
import SwiftUI

struct EmotionDetailView: View {
    let emotion: Emotion
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var showingDeleteAlert = false
    @State private var showingEditView = false
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            NavigationView {
                ZStack {
                    AnimatedGlassBackground(color: emotion.type.color)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Header
                            headerView
                            
                            // Details
                            VStack(alignment: .leading, spacing: 20) {
                                intensitySection
                                
                                Divider().padding(.horizontal)
                                
                                if !emotion.note.isEmpty {
                                    noteSection
                                    Divider().padding(.horizontal)
                                }
                                
                                if let location = emotion.location {
                                    locationSection(location: location)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { navigationToolbar }
                    .alert("Delete Emotion?", isPresented: $showingDeleteAlert, actions: deleteAlertActions, message: {
                        Text("Are you sure you want to delete this emotion record?")
                    })
                }
                .sheet(isPresented: $showingEditView) {
                    EditEmotionView(emotion: emotion)
                }
            }
        } else {
            // MARK: - iOS 18 Design
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
                    ToolbarItem(placement: .navigationBarLeading) { Button("Done") { dismiss() } }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 16) {
                            Button(action: { showingEditView = true }) { Image(systemName: "pencil").foregroundColor(Color("AccentColor")) }
                            Button(action: { showingDeleteAlert = true }) { Image(systemName: "trash").foregroundColor(.red) }
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
    
    // MARK: - iOS 26 View Components
    
    @available(iOS 26.0, *)
    private var headerView: some View {
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
        .background(.regularMaterial)
        .overlay(
            emotion.type.gradient
                .opacity(0.3)
                .blendMode(.multiply)
        )
        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
        .shadow(radius: 10)
    }

    @available(iOS 26.0, *)
    private var intensitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
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
        .padding()
        .background(.thinMaterial)
        .cornerRadius(16)
        .overlay(luminousBorder)
    }

    @available(iOS 26.0, *)
    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Notes", systemImage: "note.text")
                .font(.headline)
            
            Text(emotion.note)
                .font(.body)
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(16)
        .overlay(luminousBorder)
    }

    @available(iOS 26.0, *)
    private func locationSection(location: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Location", systemImage: "location.fill")
                .font(.headline)
            
            Text(location)
                .font(.body)
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(16)
        .overlay(luminousBorder)
    }

    @available(iOS 26.0, *)
    private var luminousBorder: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(.white.opacity(0.3), lineWidth: 1)
    }

    @ToolbarContentBuilder
    private var navigationToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) { Button("Done") { dismiss() } }
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 16) {
                Button(action: { showingEditView = true }) { Image(systemName: "pencil").foregroundColor(Color("AccentColor")) }
                Button(action: { showingDeleteAlert = true }) { Image(systemName: "trash").foregroundColor(.red) }
            }
        }
    }

    @ViewBuilder
    private func deleteAlertActions() -> some View {
        Button("Delete", role: .destructive) {
            dataManager.deleteEmotion(emotion)
            dismiss()
        }
        Button("Cancel", role: .cancel) {}
    }
}
