# MindFilter

MindFilter was designed for iPad to turn ad breaks into quick language practice. When an unskippable YouTube ad starts, swipe MindFilter into view with Slide Over. The app lowers the video volume and lets you mute it with a tap. Even a 15-second break is enough to review a word or learn a new one before getting back to the video.

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
