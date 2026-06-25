import SwiftUI

/// The whole screen: a full-bleed canvas with the single toolbar floating at
/// the top. There is no other navigation, no menus, nothing to get lost in.
struct ContentView: View {
    @StateObject private var state = AppState()

    var body: some View {
        // The whole app is pinned to one fixed landscape orientation: it never
        // rotates and always fills the screen, like a sheet of paper.
        OrientationLock {
            ZStack(alignment: .top) {
                CanvasView(state: state)
                    .ignoresSafeArea()

                ToolbarView(state: state)
            }
        }
        .statusBarHidden(true)
        // Keep the home indicator out of the way so the canvas truly fills
        // the screen and there is nothing to accidentally swipe.
        .persistentSystemOverlays(.hidden)
    }
}

#Preview {
    ContentView()
}
