import SwiftUI
import UIKit

/// Tracks the current interface orientation of the app's window scene.
///
/// We let the app support every device orientation so iPadOS never letterboxes
/// us — but we use this to counter-rotate the content and keep the UI visually
/// fixed (see `OrientationLock`).
@MainActor
final class OrientationMonitor: ObservableObject {
    @Published var orientation: UIInterfaceOrientation = .landscapeRight
    private var observer: NSObjectProtocol?

    init() {
        refresh()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        observer = NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refresh()
        }
    }

    deinit {
        if let observer { NotificationCenter.default.removeObserver(observer) }
    }

    private func refresh() {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        guard let scene = scenes.first(where: { $0.activationState == .foregroundActive }) ?? scenes.first
        else { return }
        if scene.interfaceOrientation != .unknown {
            orientation = scene.interfaceOrientation
        }
    }
}

/// Pins its content to a single, fixed landscape orientation — the app never
/// rotates and always fills the whole screen, like a sheet of paper taped to
/// the glass. Turning the iPad does not reflow the layout; the color palette
/// stays on the same screen edge, exactly as if rotation were locked system-wide.
///
/// How it works: the app declares support for all orientations (so iPadOS gives
/// us a full-screen window in every position and never letterboxes), and we
/// counter-rotate the content to cancel out whatever rotation the system applied.
struct OrientationLock<Content: View>: View {
    @StateObject private var monitor = OrientationMonitor()
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { geo in
            let longSide = max(geo.size.width, geo.size.height)
            let shortSide = min(geo.size.width, geo.size.height)
            content
                .frame(width: longSide, height: shortSide)   // always laid out landscape
                .rotationEffect(counterRotation)              // cancel the system's rotation
                .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        // Snap instantly instead of animating, so the content appears perfectly
        // still while the device turns around it.
        .animation(nil, value: monitor.orientation)
    }

    /// The rotation that maps the system's current orientation back to a fixed
    /// landscape-right presentation.
    private var counterRotation: Angle {
        switch monitor.orientation {
        case .landscapeRight:      return .degrees(0)
        case .landscapeLeft:       return .degrees(180)
        case .portrait:            return .degrees(90)
        case .portraitUpsideDown:  return .degrees(-90)
        default:                   return .degrees(0)
        }
    }
}
