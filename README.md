# MindFilter

MindFilter is an iPad microlearning concept that turns short waits into a chance to learn something. Open it beside another app, read a short fact in a topic you care about, and return to what you were doing.

This repository contains the [product requirements document](MindFilter_PRD.md) in French. It covers the target user, the core interaction, the MVP scope, and the technical choices for a native iPad app.

## The proposed experience

- Get to a learning card in a single gesture using iPad multitasking.
- Choose categories, save facts as favorites, and avoid seeing the same cards too often.
- Read offline, with content and preferences stored on the device.

## Design and architecture

I scoped the MVP around a short reading session and designed the interaction for a narrow multitasking window. The proposed stack uses SwiftUI for the interface, bundled JSON for the initial content, and SwiftData for favorites, reading history, and preferences.
