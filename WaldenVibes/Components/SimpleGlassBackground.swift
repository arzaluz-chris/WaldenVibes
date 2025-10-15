//
//  SimpleGlassBackground.swift
//  WaldenVibes
//
//  Created by Claude Code
//

import SwiftUI

/// Fondo estático glassmórfico para vistas secundarias y modales
/// Usa un gradiente simple sin animaciones para mejor rendimiento
@available(iOS 26.0, *)
struct SimpleGlassBackground: View {
    let color: Color

    var body: some View {
        LinearGradient(
            colors: [color.opacity(0.3), .clear],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
