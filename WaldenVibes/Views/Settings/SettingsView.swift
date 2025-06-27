// WaldenVibes/Views/Settings/SettingsView.swift
import SwiftUI
import UserNotifications

struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    @AppStorage("selectedTheme") private var selectedTheme = "system"
    @AppStorage("appLanguage") private var appLanguage = "es"
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("notificationTime") private var notificationTime = Date()
    
    @State private var showingDeleteAlert = false
    @State private var showingAbout = false
    @State private var showingPrivacy = false
    
    var body: some View {
        Form {
            // Appearance Section
            Section {
                Picker("settings.theme", selection: $selectedTheme) {
                    Label("theme.system", systemImage: "circle.lefthalf.filled")
                        .tag("system")
                    Label("theme.light", systemImage: "sun.max.fill")
                        .tag("light")
                    Label("theme.dark", systemImage: "moon.fill")
                        .tag("dark")
                }
                
                Picker("settings.language", selection: $appLanguage) {
                    Text("Español")
                        .tag("es")
                    Text("English")
                        .tag("en")
                }
            } header: {
                Text("settings.appearance")
            }
            
            // Notifications Section
            Section {
                Toggle("settings.notifications.enable", isOn: $notificationsEnabled)
                    .onChange(of: notificationsEnabled) { _, newValue in
                        if newValue {
                            requestNotificationPermission()
                        } else {
                            cancelAllNotifications()
                        }
                    }
                
                if notificationsEnabled {
                    DatePicker(
                        "settings.notifications.time",
                        selection: $notificationTime,
                        displayedComponents: .hourAndMinute
                    )
                    .onChange(of: notificationTime) { _, _ in
                        scheduleNotification()
                    }
                }
            } header: {
                Text("settings.notifications")
            } footer: {
                if notificationsEnabled {
                    Text("settings.notifications.footer")
                }
            }
            
            // Data Management Section
            Section {
                Button(action: { showingDeleteAlert = true }) {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                        Text("settings.data.clear")
                            .foregroundColor(.red)
                    }
                }
                
                NavigationLink(destination: ExportView()) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Color("AccentColor"))
                        Text("settings.data.export")
                    }
                }
            } header: {
                Text("settings.data")
            }
            
            // About Section
            Section {
                Button(action: { showingAbout = true }) {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color("AccentColor"))
                        Text("settings.about")
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
                        Text("settings.privacy")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
            } header: {
                Text("settings.info")
            }
            
            // App Version
            Section {
                HStack {
                    Text("settings.version")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("nav.settings")
        .alert("settings.data.clear.confirm.title", isPresented: $showingDeleteAlert) {
            Button("cancel", role: .cancel) {}
            Button("delete", role: .destructive) {
                dataManager.clearAllData()
            }
        } message: {
            Text("settings.data.clear.confirm.message")
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .sheet(isPresented: $showingPrivacy) {
            PrivacyView()
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
        content.title = NSLocalizedString("notification.title", comment: "")
        content.body = NSLocalizedString("notification.body", comment: "")
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
