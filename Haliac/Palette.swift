import SwiftUI
import UIKit

/// A single, curated drawing color presented as a large circular button.
struct PaletteColor: Identifiable, Equatable {
    let id: String
    let name: String
    let uiColor: UIColor

    var color: Color { Color(uiColor) }
}

/// The curated rainbow palette. Deliberately tiny — no picker, no custom colors.
/// Colors are vivid and high-contrast against the white canvas so a child can
/// recognize them at a glance.
enum Palette {
    static let colors: [PaletteColor] = [
        PaletteColor(id: "red",     name: "Red",     uiColor: UIColor(red: 0.91, green: 0.18, blue: 0.21, alpha: 1)),
        PaletteColor(id: "orange",  name: "Orange",  uiColor: UIColor(red: 0.97, green: 0.51, blue: 0.06, alpha: 1)),
        PaletteColor(id: "yellow",  name: "Yellow",  uiColor: UIColor(red: 0.98, green: 0.80, blue: 0.08, alpha: 1)),
        PaletteColor(id: "lime",    name: "Lime",    uiColor: UIColor(red: 0.55, green: 0.78, blue: 0.18, alpha: 1)),
        PaletteColor(id: "green",   name: "Green",   uiColor: UIColor(red: 0.18, green: 0.69, blue: 0.30, alpha: 1)),
        PaletteColor(id: "teal",    name: "Teal",    uiColor: UIColor(red: 0.10, green: 0.71, blue: 0.67, alpha: 1)),
        PaletteColor(id: "cyan",    name: "Cyan",    uiColor: UIColor(red: 0.20, green: 0.74, blue: 0.92, alpha: 1)),
        PaletteColor(id: "blue",    name: "Blue",    uiColor: UIColor(red: 0.13, green: 0.46, blue: 0.90, alpha: 1)),
        PaletteColor(id: "purple",  name: "Purple",  uiColor: UIColor(red: 0.55, green: 0.27, blue: 0.86, alpha: 1)),
        PaletteColor(id: "pink",    name: "Pink",    uiColor: UIColor(red: 0.95, green: 0.36, blue: 0.62, alpha: 1)),
        PaletteColor(id: "brown",   name: "Brown",   uiColor: UIColor(red: 0.60, green: 0.40, blue: 0.24, alpha: 1)),
        PaletteColor(id: "gray",    name: "Grey",    uiColor: UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)),
        PaletteColor(id: "black",   name: "Black",   uiColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1)),
    ]

    static var first: PaletteColor { colors[0] }
}
