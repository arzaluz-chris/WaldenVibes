// WaldenVibes/Views/Settings/SettingsView.swift
import SwiftUI
import UserNotifications

struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    @AppStorage("selectedTheme") private var selectedTheme = "system"
    // Removed appLanguage setting to prevent in-app language changes
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("notificationTime") private var notificationTime = Date()
    
    @State private var showingDeleteAlert = false
    @State private var showingAbout = false
    @State private var showingPrivacy = false
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            ZStack {
                AnimatedGlassBackground(color: .green)

                Form {
                    // Appearance Section
                    Section {
                        Picker("Theme", selection: $selectedTheme) {
                            Label("System", systemImage: "circle.lefthalf.filled")
                                .tag("system")
                            Label("Light", systemImage: "sun.max.fill")
                                .tag("light")
                            Label("Dark", systemImage: "moon.fill")
                                .tag("dark")
                        }
                    } header: {
                        Text("Appearance", comment: "Settings section header")
                    }
                    .listRowBackground(
                        Color.clear
                            .background(.thinMaterial)
                            .cornerRadius(12)
                    )
            
                    // Notifications Section
                    Section {
                        Toggle("Enable reminders", isOn: $notificationsEnabled)
                            .onChange(of: notificationsEnabled) { _, newValue in
                                if newValue {
                                    requestNotificationPermission()
                                } else {
                                    cancelAllNotifications()
                                }
                            }

                        if notificationsEnabled {
                            DatePicker(
                                "Reminder time",
                                selection: $notificationTime,
                                displayedComponents: .hourAndMinute
                            )
                            .onChange(of: notificationTime) { _, _ in
                                scheduleNotification()
                            }
                        }
                    } header: {
                        Text("Notifications", comment: "Settings section header")
                    } footer: {
                        if notificationsEnabled {
                            Text("Receive a daily reminder to record your emotions", comment: "Settings footer text")
                        }
                    }
                    .listRowBackground(
                        Color.clear
                            .background(.thinMaterial)
                            .cornerRadius(12)
                    )
            
                    // Data Management Section
                    Section {
                        Button(action: { showingDeleteAlert = true }) {
                            HStack {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                Text("Clear All Data", comment: "Settings option to delete all data")
                                    .foregroundColor(.red)
                            }
                        }

                        NavigationLink(destination: ExportView()) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(Color("AccentColor"))
                                Text("Export Data", comment: "Settings option to export data")
                            }
                        }
                    } header: {
                        Text("Data Management", comment: "Settings section header")
                    }
                    .listRowBackground(
                        Color.clear
                            .background(.thinMaterial)
                            .cornerRadius(12)
                    )
            
                    // About Section
                    Section {
                        Button(action: { showingAbout = true }) {
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color("AccentColor"))
                                Text("About", comment: "Settings option")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }

                        Button(action: { showingPrivacy = true }) {
                            HStack {
                                Image(systemName: "lock.shield")
                                    .foregroundColor(Color("AccentColor"))
                                Text("Privacy Policy", comment: "Settings option")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    } header: {
                        Text("Information", comment: "Settings section header")
                    }
                    .listRowBackground(
                        Color.clear
                            .background(.thinMaterial)
                            .cornerRadius(12)
                    )
            
                    // App Version
                    Section {
                        HStack {
                            Text("Version", comment: "App version label")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.secondary)
                        }
                    }
                    .listRowBackground(
                        Color.clear
                            .background(.thinMaterial)
                            .cornerRadius(12)
                    )
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .alert("Delete All Data?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    dataManager.clearAllData()
                }
            } message: {
                Text("This will permanently delete all your emotions, moments, and stress records. This action cannot be undone.")
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
            .sheet(isPresented: $showingPrivacy) {
                PrivacyView()
            }
        } else {
            // MARK: - iOS 18 Design
            Form {
                // Appearance Section
                Section {
                    Picker("Theme", selection: $selectedTheme) {
                        Label("System", systemImage: "circle.lefthalf.filled")
                            .tag("system")
                        Label("Light", systemImage: "sun.max.fill")
                            .tag("light")
                        Label("Dark", systemImage: "moon.fill")
                            .tag("dark")
                    }
                } header: {
                    Text("Appearance", comment: "Settings section header")
                }

                // Notifications Section
                Section {
                    Toggle("Enable reminders", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { _, newValue in
                            if newValue {
                                requestNotificationPermission()
                            } else {
                                cancelAllNotifications()
                            }
                        }

                    if notificationsEnabled {
                        DatePicker(
                            "Reminder time",
                            selection: $notificationTime,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: notificationTime) { _, _ in
                            scheduleNotification()
                        }
                    }
                } header: {
                    Text("Notifications", comment: "Settings section header")
                } footer: {
                    if notificationsEnabled {
                        Text("Receive a daily reminder to record your emotions", comment: "Settings footer text")
                    }
                }

                // Data Management Section
                Section {
                    Button(action: { showingDeleteAlert = true }) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                            Text("Clear All Data", comment: "Settings option to delete all data")
                                .foregroundColor(.red)
                        }
                    }

                    NavigationLink(destination: ExportView()) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(Color("AccentColor"))
                            Text("Export Data", comment: "Settings option to export data")
                        }
                    }
                } header: {
                    Text("Data Management", comment: "Settings section header")
                }

                // About Section
                Section {
                    Button(action: { showingAbout = true }) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(Color("AccentColor"))
                            Text("About", comment: "Settings option")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }

                    Button(action: { showingPrivacy = true }) {
                        HStack {
                            Image(systemName: "lock.shield")
                                .foregroundColor(Color("AccentColor"))
                            Text("Privacy Policy", comment: "Settings option")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                } header: {
                    Text("Information", comment: "Settings section header")
                }

                // App Version
                Section {
                    HStack {
                        Text("Version", comment: "App version label")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Delete All Data?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    dataManager.clearAllData()
                }
            } message: {
                Text("This will permanently delete all your emotions, moments, and stress records. This action cannot be undone.")
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
            .sheet(isPresented: $showingPrivacy) {
                PrivacyView()
            }
        }
    }
    
    // MARK: - Notification Methods
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    scheduleNotification()
                } else {
                    notificationsEnabled = false
                }
            }
        }
    }
    
    private func scheduleNotification() {
        cancelAllNotifications()
        
        let content = UNMutableNotificationContent()
        content.title = String(localized: "Daily Reminder", comment: "Notification title")
        content.body = String(localized: "How are you feeling today? Take a moment to track your emotions.", comment: "Notification body")
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: notificationTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "daily-reminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

