# MindFilter

MindFilter is a native iPhone and iPad app that turns short waits into quick quiz sessions. Choose a topic, answer a two-choice question, and get a short explanation. On iPad, the onboarding shows how to use the app alongside another app.

- **1,145 offline questions** covering general knowledge and French, English, Spanish, and German.
- **Adaptive review** that brings back missed questions and tracks which ones you’ve mastered.
- **On-device progress** with quiz history, statistics, and category preferences.

## Start with the code

| Feature | Where to look |
| --- | --- |
| SwiftUI entry point and SwiftData setup | [MindFilterApp.swift](MindFilter/MindFilterApp.swift) |
| Quiz flow and feedback | [QuizReaderView.swift](MindFilter/Views/QuizReaderView.swift) |
| Question selection and review | [QuestionSelector.swift](MindFilter/Services/QuestionSelector.swift) |
| Offline question packs | [Resources](MindFilter/Resources/) |
| Local purchase testing | [Products.storekit](MindFilter/Products.storekit) |

## Run locally

Open [MindFilter.xcodeproj](MindFilter.xcodeproj) on a Mac in Xcode, select the `MindFilter` scheme, choose an iPhone or iPad simulator, and run the app. The project targets iOS and iPadOS 18.5 or later. Use your own Apple Developer team in Signing & Capabilities if you run the app on a physical device.

The [product requirements document](MindFilter_PRD.md) captures the original concept in French.
