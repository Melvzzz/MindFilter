import SwiftUI

struct ContentView: View {
    @StateObject private var settings = SettingsViewModel()
    @EnvironmentObject private var store: StoreManager
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false

    var body: some View {
        if onboardingCompleted {
            QuizReaderView()
                .environmentObject(settings)
                .environmentObject(store)
        } else {
            OnboardingView()
                .environmentObject(settings)
                .environmentObject(store)
        }
    }
}
