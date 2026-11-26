import SwiftUI
import SwiftData
import AVFoundation

@main
struct MindFilterApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var storeManager = StoreManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storeManager)
        }
        .modelContainer(for: [QuizResult.self, HistoryEntry.self, QuestionProgress.self])
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                if UserDefaults.standard.object(forKey: "duckingEnabled") == nil || UserDefaults.standard.bool(forKey: "duckingEnabled") {
                    activateDucking()
                }
            case .background, .inactive:
                VolumeController.shared.unmute()
                deactivateDucking()
            @unknown default:
                break
            }
        }
    }

    /// Active le ducking pour réduire le volume des autres apps (YouTube, etc.)
    private func activateDucking() {
        #if os(iOS)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, options: .duckOthers)
            try session.setActive(true)
        } catch {
            print("⚠️ Erreur activation ducking: \(error)")
        }
        #endif
    }

    /// Désactive la session pour que les autres apps reprennent leur volume normal
    private func deactivateDucking() {
        #if os(iOS)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("⚠️ Erreur désactivation ducking: \(error)")
        }
        #endif
    }
}
