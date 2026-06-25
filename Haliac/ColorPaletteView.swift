import SwiftUI

/// A single row of large circular color buttons. The selected one grows and
/// gains a ring so it is obvious — without any words — which color is active.
///
/// Deliberately one row and never a scroll view: a child poking at the colors
/// must never trigger a scroll/drag that slides the palette around. To keep
/// every swatch on screen at once (the app is locked to portrait, the narrow
/// dimension), the swatches size themselves down to fill the available width,
/// up to a comfortable maximum — as large as the device allows, no clipping.
struct ColorPaletteView: View {
    @ObservedObject var state: AppState

    private let spacing: CGFloat = 14
    private let maxDiameter: CGFloat = 56
    /// Headroom so the selected swatch's grow-and-shadow isn't clipped.
    private let selectedScale: CGFloat = 1.18

    var body: some View {
        GeometryReader { geo in
            let count = CGFloat(Palette.colors.count)
            let fit = (geo.size.width - spacing * (count - 1)) / count
            let diameter = max(0, min(maxDiameter, fit))

            HStack(spacing: spacing) {
                ForEach(Palette.colors) { color in
                    swatch(color, diameter: diameter)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .frame(height: maxDiameter * selectedScale)
    }

    @ViewBuilder
    private func swatch(_ color: PaletteColor, diameter: CGFloat) -> some View {
        let isSelected = state.tool == .brush && state.selectedColor == color
        Button {
            state.selectColor(color)
        } label: {
            Circle()
                .fill(color.color)
                .frame(width: diameter, height: diameter)
                .overlay(
                    Circle().strokeBorder(.black.opacity(0.12), lineWidth: 1)
                )
                .overlay(
                    Circle()
                        .strokeBorder(.white, lineWidth: isSelected ? 5 : 0)
                        .padding(3)
                )
                .scaleEffect(isSelected ? selectedScale : 1.0)
                .shadow(color: .black.opacity(isSelected ? 0.22 : 0), radius: 6, y: 2)
                .animation(.spring(response: 0.28, dampingFraction: 0.6), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(color.name)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}
