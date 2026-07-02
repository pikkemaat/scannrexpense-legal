import SwiftUI
import SwiftData

@main
struct PositiveHealthApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: Assessment.self)
    }
}
