// WaldenVibes/Utilities/Constants.swift
import SwiftUI

struct Constants {
    // Animation
    static let animationDuration = 0.3
    static let springAnimation = Animation.spring(response: 0.4, dampingFraction: 0.8)
    
    // Layout
    static let cornerRadius: CGFloat = 12
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    static let largePadding: CGFloat = 24
    
    // Sizes
    static let iconSize: CGFloat = 24
    static let largeIconSize: CGFloat = 40
    static let buttonHeight: CGFloat = 50
    static let cardShadowRadius: CGFloat = 5
    
    // Colors (Fallback hex values if Asset Catalog fails)
    static let accentColorHex = "9966CC"
    static let happyColorHex = "FFD700"
    static let sadColorHex = "6495ED"
    static let anxiousColorHex = "9370DB"
    static let calmColorHex = "90EE90"
    static let angryColorHex = "FF6B6B"
    
    // App Info
    static let appVersion = "1.0.0"
    static let appName = "Walden Vibes"
    static let developerName = "Walden Vibes Team"
    
    // UserDefaults Keys
    static let hasSeenOnboardingKey = "hasSeenOnboarding"
    static let selectedThemeKey = "selectedTheme"
    static let appLanguageKey = "appLanguage"
    static let notificationsEnabledKey = "notificationsEnabled"
    static let notificationTimeKey = "notificationTime"
}
