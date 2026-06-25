import SwiftUI

/// The only chrome in the app: a single top bar holding the color palette and
/// the eraser. Large targets, high contrast, no text required to understand it.
struct ToolbarView: View {
    @ObservedObject var state: AppState

    var body: some View {
        HStack(spacing: 28) {
            // Takes the width left by the eraser; its swatches size to fit it.
            ColorPaletteView(state: state)

            EraserButton(state: state)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
    }
}

/// The eraser, shown as a big white circle so it reads as "the white color"
/// — which is exactly what it is.
private struct EraserButton: View {
    @ObservedObject var state: AppState

    private let diameter: CGFloat = 56

    var body: some View {
        let isSelected = state.tool == .eraser
        Button {
            state.selectEraser()
        } label: {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: diameter, height: diameter)
                    .overlay(Circle().strokeBorder(.black.opacity(0.18), lineWidth: 1))
                Image(systemName: "eraser.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.black.opacity(0.55))
            }
            .overlay(
                Circle()
                    .strokeBorder(.blue, lineWidth: isSelected ? 5 : 0)
                    .padding(3)
            )
            .scaleEffect(isSelected ? 1.18 : 1.0)
            .shadow(color: .black.opacity(isSelected ? 0.22 : 0), radius: 6, y: 2)
            .animation(.spring(response: 0.28, dampingFraction: 0.6), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Eraser")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}
