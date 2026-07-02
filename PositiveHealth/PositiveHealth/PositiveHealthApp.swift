import SwiftUI
import SwiftData

@main
struct PositiveHealthApp: App {
    @State private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(settings)
                .environment(\.locale, settings.language.locale)
        }
        .modelContainer(for: Assessment.self)
    }
}
