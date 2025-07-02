// WaldenVibes/Components/EmptyStateView.swift
import SwiftUI

struct EmptyStateView: View {
    let imageName: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let buttonTitle: LocalizedStringKey?
    let buttonAction: (() -> Void)?
    
    init(
        imageName: String,
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey,
        buttonTitle: LocalizedStringKey? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Check if it's a system image or custom image
            if imageName.contains(".") {
                // Custom image from Assets
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .opacity(0.5)
            } else {
                // SF Symbol
                Image(systemName: imageName)
                    .font(.system(size: 80))
                    .foregroundColor(Color("AccentColor").opacity(0.5))
            }
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(subtitle)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
                Button(action: buttonAction) {
                    Label(buttonTitle, systemImage: "plus.circle.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color("AccentColor"))
                        .cornerRadius(25)
                }
                .padding(.top, 10)
            }
        }
    }
}
