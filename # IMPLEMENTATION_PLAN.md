# IMPLEMENTATION_PLAN.md

# Haliac

> *Inspired by Bob Ross' philosophy: "We don't make mistakes, just happy little accidents."*

## Vision

Haliac is an iPad drawing app designed for young children and users who benefit from an intentionally simplified interface.

The goal is not to provide a feature-rich painting application, but to create the easiest possible drawing experience with zero cognitive overhead.

Every interaction should feel safe, forgiving, and joyful.

---

# Design Principles

## Accessibility First

The application should be usable without reading.

Large touch targets.

No hidden gestures.

No complex menus.

---

## Minimalism

Everything unnecessary is removed.

The child should always know what to do next.

Drawing is always the primary interaction.

---

## No Wrong Actions

There are no destructive operations.

Undo is available only in form of eraser tool (white color).

Accidental finger touches should have minimal consequences, pencil first design.

The interface should encourage exploration rather than correctness.

---

## Fast

The app should launch immediately.

Canvas creation should be instant.

No loading screens.

No onboarding.

---

# MVP

## Canvas

- Infinite white canvas (or generously sized canvas)
- Finger drawing
- Apple Pencil support
- Smooth stroke rendering

---

## Brush

One brush only.

Properties:

- round
- pressure independent
- consistent width
- anti-aliased

No brush picker.

---

## Colors

Very small curated palette following the colors of the rainbow.

Large circular buttons.

---

## Eraser

Single erase tool (white color).

No settings.

---

# User Interface

Landscape-first.

Canvas occupies nearly the full screen.

Top toolbar:

- Color palette

Nothing else.

---

# Accessibility

- Large controls
- High contrast
- Dynamic Type where applicable
- Haptic feedback for tool selection
- Large touch areas
- No multi-finger gestures required

---

# Architecture

SwiftUI

Suggested structure:

```
App
 ├── CanvasView
 ├── ToolbarView
 ├── ColorPaletteView
 ├── DrawingEngine
 ├── DrawingDocument
 └── Settings
```

---

# State

Simple application state.

```
Current Tool

Current Color

Current Drawing

```

Avoid unnecessary abstraction.

---


# Performance

60–120 FPS drawing.

Low latency.

Memory efficient.

Avoid unnecessary redraws.

---



# Success Criteria

A four-year-old can:

- open the app
- immediately start drawing
- change colors independently
- erase mistakes
- create something without adult assistance

The interface should disappear and let creativity take over.