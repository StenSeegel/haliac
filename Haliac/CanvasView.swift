import SwiftUI
import PencilKit

/// The drawing surface. Wraps `PKCanvasView`, which gives us low-latency,
/// 60–120 FPS, anti-aliased stroke rendering, Apple Pencil support and palm
/// rejection essentially for free — letting the rest of the app stay tiny.
struct CanvasView: UIViewRepresentable {
    @ObservedObject var state: AppState

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = DrawingCanvas()

        // A plain white sheet, locked in place — no scrolling or zooming a
        // child could get lost in.
        canvas.backgroundColor = .white
        canvas.isOpaque = true

        // The sheet is always white, so pin the canvas to a light appearance.
        // Otherwise, in dark mode, PencilKit "helpfully" inverts near-black ink
        // toward white for contrast — and a black pencil would draw invisibly
        // on white. Pinning light makes every palette color render as authored.
        canvas.overrideUserInterfaceStyle = .light
        canvas.isScrollEnabled = false
        canvas.bouncesZoom = false
        canvas.minimumZoomScale = 1
        canvas.maximumZoomScale = 1

        // Pencil only: the Apple Pencil draws; fingers and palms do nothing at
        // all — no stray marks, and (via `DrawingCanvas`) no edit menu either.
        canvas.drawingPolicy = .pencilOnly

        applyTool(to: canvas)

        // Opt-in seam (off in normal use) that seeds a sample drawing so the
        // canvas can be verified/screenshotted without live touch input.
        if ProcessInfo.processInfo.environment["HALIAC_DEMO"] == "1" {
            canvas.drawing = DemoDrawing.make()
        }

        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        applyTool(to: canvas)
    }

    /// Configures the active tool. The brush is PencilKit's `.pencil` ink — the
    /// one stock ink that genuinely responds to Apple Pencil tilt: held upright
    /// it lays a fine line, tipped onto its side it shades broad, exactly like a
    /// wooden colored pencil, and it does so *live* as you draw (no after-the-
    /// fact width pass, so nothing flickers or jumps). The eraser is PencilKit's
    /// real eraser, which lifts existing strokes rather than painting over them.
    /// (A white inking tool only looks like erasing on a white sheet, and
    /// PencilKit even inverts white ink to black for contrast in dark mode — so
    /// it would paint black, not erase.)
    private func applyTool(to canvas: PKCanvasView) {
        switch state.tool {
        case .brush:
            canvas.tool = PKInkingTool(.pencil, color: state.activeColor, width: state.activeWidth)
        case .eraser:
            canvas.tool = PKEraserTool(.bitmap, width: state.eraserWidth)
        }
    }
}

/// A `PKCanvasView` that refuses every finger affordance. Drawing is already
/// limited to the Pencil by `drawingPolicy`, but a finger long-press would
/// still summon UIKit's editing menu ("Select", "Insert space", …). That menu
/// can only appear while the view is first responder and an action is allowed,
/// so we deny both — leaving fingers with nothing to trigger.
final class DrawingCanvas: PKCanvasView {
    private static let pencilOnly = [NSNumber(value: UITouch.TouchType.pencil.rawValue)]

    override var canBecomeFirstResponder: Bool { false }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }

    /// `drawingPolicy` only governs the *drawing* gesture. PencilKit installs
    /// further recognizers (long-press selection, etc.) that still react to a
    /// finger and pop a selection menu. Pin every recognizer the canvas adds —
    /// now or lazily later — to Pencil-only touches, so a finger triggers
    /// nothing whatsoever.
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        gestureRecognizer.allowedTouchTypes = Self.pencilOnly
        super.addGestureRecognizer(gestureRecognizer)
    }

    /// The previous overrides only reach recognizers PencilKit adds *directly to
    /// the canvas*. In practice it installs the long-press selection recognizer
    /// and the modern `UIEditMenuInteraction` (iOS 16+) on **internal
    /// subviews**, which `addGestureRecognizer` never sees and which
    /// `canPerformAction` (an old `UIMenuController` hook) no longer governs.
    /// PencilKit also (re)creates these lazily, so we re-sweep the whole subtree
    /// every layout pass: pin each recognizer to the Pencil and tear out every
    /// edit-menu interaction, leaving a finger with nothing to summon.
    override func layoutSubviews() {
        super.layoutSubviews()
        disableFingerMenu(in: self)
    }

    private func disableFingerMenu(in view: UIView) {
        for recognizer in view.gestureRecognizers ?? [] {
            recognizer.allowedTouchTypes = Self.pencilOnly
        }
        for interaction in view.interactions where interaction is UIEditMenuInteraction {
            view.removeInteraction(interaction)
        }
        for subview in view.subviews {
            disableFingerMenu(in: subview)
        }
    }
}

/// Builds a few colorful sample strokes. Used only by the `HALIAC_DEMO` seam.
private enum DemoDrawing {
    static func make() -> PKDrawing {
        var strokes: [PKStroke] = []
        for (index, color) in Palette.colors.enumerated() {
            let y = 220.0 + Double(index) * 90.0
            let points = stride(from: 120.0, through: 900.0, by: 8.0).map { x -> PKStrokePoint in
                let wobble = sin(x / 60.0 + Double(index)) * 28.0
                return PKStrokePoint(location: CGPoint(x: x, y: y + wobble),
                                     timeOffset: 0,
                                     size: CGSize(width: 14, height: 14),
                                     opacity: 1,
                                     force: 1,
                                     azimuth: 0,
                                     altitude: 0)
            }
            let path = PKStrokePath(controlPoints: points, creationDate: Date(timeIntervalSinceReferenceDate: 0))
            strokes.append(PKStroke(ink: PKInk(.monoline, color: color.uiColor), path: path))
        }
        return PKDrawing(strokes: strokes)
    }
}
