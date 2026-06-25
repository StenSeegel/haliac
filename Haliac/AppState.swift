import SwiftUI
import UIKit

/// The two — and only two — things a user can do: draw, or erase.
enum Tool: Equatable {
    case brush
    case eraser
}

/// The entire application state. Intentionally flat: a current tool and a
/// current color. There is nothing else to track.
@MainActor
final class AppState: ObservableObject {
    @Published var tool: Tool = .brush
    @Published var selectedColor: PaletteColor = Palette.first

    /// Nominal width of the pencil, in points — a fine point, like a freshly
    /// sharpened pencil. The `.pencil` ink modulates this live with Apple
    /// Pencil force and tilt, broadening as the Pencil is laid on its side.
    let brushWidth: CGFloat = 5

    /// Width of the eraser, in points. Wider than the brush so it feels
    /// forgiving. The eraser lifts strokes rather than painting over them.
    let eraserWidth: CGFloat = 46

    /// The brush color applied to the canvas.
    var activeColor: UIColor { selectedColor.uiColor }

    /// The brush line width.
    var activeWidth: CGFloat { brushWidth }

    // MARK: - Actions (each gives gentle haptic confirmation)

    func selectColor(_ color: PaletteColor) {
        selectedColor = color
        tool = .brush
        Haptics.select()
    }

    func selectEraser() {
        tool = .eraser
        Haptics.select()
    }
}

/// Tiny haptics helper so tool selection feels physical and confirming.
enum Haptics {
    static func select() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
