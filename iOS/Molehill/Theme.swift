import SwiftUI

/// Unique visual identity for Molehill.
enum Theme {
    static let background = Color(hex: "#241A12")
    static let accent = Color(hex: "#C97B3D")
    static let secondary = Color(hex: "#8A9A5B")
    static let textPrimary = Color(hex: "#F2E9DD")

    static let titleFont: Font = .system(.largeTitle, design: .default).weight(.bold)
    static let bodyFont: Font = .system(.body, design: .default)

    static let cardCorner: CGFloat = 18
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
