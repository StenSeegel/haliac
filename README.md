# Haliac

A radically simple iPad drawing app for young children and anyone who benefits
from a deliberately minimal interface.

> *"We don't make mistakes, just happy little accidents."* — Bob Ross

The goal isn't a feature-rich paint program — it's the easiest possible drawing
experience, with zero cognitive overhead. The app launches straight into a blank
sheet: no menus, no onboarding, no settings, nothing to get lost in.

## What it does

- **One white canvas** that fills the entire screen — no scrolling, no zooming,
  nothing to pan away from.
- **Apple Pencil drawing.** Input is Pencil-only: a resting hand, palm, or stray
  finger leaves no marks and can't trigger any menu. The Pencil is the brush.
- **One brush** — PencilKit's `.pencil` ink. Held upright it lays a fine line;
  tipped onto its side it shades broad, responding live to tilt and pressure,
  just like a wooden colored pencil.
- **A 13-color palette** of large circular buttons — red, orange, yellow, lime,
  green, teal, cyan, blue, purple, pink, brown, grey, black. The selected color
  grows and gains a ring, so it's obvious without any words. Tapping a color is
  the only way to switch; there's no picker and no custom colors.
- **One eraser** — a real eraser that lifts strokes (not white paint), wide and
  forgiving. It's the closest thing to "undo," kept gentle and non-destructive.
- **Haptic feedback** on every color/tool tap, so selection feels physical.
- **Locked orientation.** The interface never rotates and always fills the
  screen — turning the iPad doesn't reflow anything, like a sheet of paper taped
  to the glass.
- **Instant launch.** No loading screens, no accounts, no first-run flow.

## Design principles

- **Accessibility first** — usable without reading; large touch targets; high
  contrast; no hidden gestures; no multi-finger gestures required.
- **Minimalism** — everything unnecessary is removed; drawing is always the
  primary (and nearly the only) interaction.
- **No wrong actions** — there are no destructive operations; the eraser is the
  only "undo," and it's forgiving.
- **Fast** — built on PencilKit for low-latency, 60–120 FPS, anti-aliased
  rendering with memory efficiency.

## Architecture

SwiftUI app, intentionally tiny — a flat state object and a thin wrapper around
PencilKit. No unnecessary abstraction.

| File | Responsibility |
|------|----------------|
| [`HaliacApp.swift`](Haliac/HaliacApp.swift) | App entry point. |
| [`ContentView.swift`](Haliac/ContentView.swift) | Full-bleed canvas with the single toolbar pinned to the top; hides the status bar and home indicator. |
| [`CanvasView.swift`](Haliac/CanvasView.swift) | `UIViewRepresentable` over `PKCanvasView`. Configures the `.pencil` brush and the bitmap eraser, pins a light appearance (so colors render true even in dark mode), and (via the `DrawingCanvas` subclass) refuses every finger affordance — including the long-press selection menu. |
| [`ToolbarView.swift`](Haliac/ToolbarView.swift) | The one bar: the color palette plus the eraser button. |
| [`ColorPaletteView.swift`](Haliac/ColorPaletteView.swift) | A single, non-scrolling row of color swatches that size themselves to fit the available width — no clipping, no accidental scrolling. |
| [`Palette.swift`](Haliac/Palette.swift) | The curated list of 13 colors. |
| [`AppState.swift`](Haliac/AppState.swift) | The entire app state: current tool, current color, brush/eraser widths, plus the haptics helper. |
| [`OrientationLock.swift`](Haliac/OrientationLock.swift) | Pins the UI to a fixed orientation: the app supports all device orientations (so iPadOS never letterboxes it) and counter-rotates the content so it never visually rotates. |

### State

Deliberately flat — there is nothing more to track:

- **Current tool** — brush or eraser.
- **Current color** — one of the palette entries.

## Requirements

- **Xcode 16+** (developed against Xcode 26.5).
- **iPadOS 17.0+**, iPad only.
- An **Apple Pencil** to draw.

## Build & run

Open `Haliac.xcodeproj` in Xcode, pick an iPad simulator or a connected iPad,
and run. The bundle identifier is `de.stenseegel.haliac` and signing uses
automatic provisioning; building to a physical device requires a development
team selected under **Signing & Capabilities**.

> Note: drawing requires an Apple Pencil, so the iPad **Simulator** shows the
> UI but can't draw with live input. To preview rendered strokes there, launch
> with the environment variable `HALIAC_DEMO=1`, which seeds a sample drawing.

## Parent setup: lock the iPad to Haliac

Haliac has no exit button, but on iPadOS only the system can stop a child from
swiping away to other apps. Use the built-in **Guided Access** feature — no
in-app setup, and Haliac needs no special configuration for it.

**One-time setup:**

1. Open **Settings → Accessibility → Guided Access** and turn it **on**. Until
   this is on, the triple-click in step 3 does nothing.
2. Tap **Passcode Settings → Set Guided Access Passcode** and choose a code.
   This is what unlocks the screen later. (You can also enable Face ID / Touch ID
   to end a session.)

**Each session:**

3. Open Haliac, then **triple-click the top button** (the on/off button on the
   top edge — *not* the volume keys), and tap **Start**. The child can now draw
   but can't leave the app.
4. To unlock, **triple-click the top button** again and enter the passcode from
   step 2.

> For a managed deployment (school or clinic), an iPad supervised via Apple
> Configurator or MDM can be pinned to Haliac automatically with Single App
> Mode, with no triple-click needed.

## Success criteria

A four-year-old can open the app, immediately start drawing, change colors
independently, erase mistakes, and create something without adult assistance —
the interface disappears and lets creativity take over.
