import SwiftUI

/// App settings — currently the language of the app and the dialogue tool.
struct SettingsView: View {
    @Environment(AppSettings.self) private var settings
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var settings = settings
        let lang = settings.language
        return NavigationStack {
            List {
                Section {
                    ForEach(AppLanguage.offered) { language in
                        Button {
                            settings.language = language
                        } label: {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(language.endonym)
                                        .foregroundStyle(.primary)
                                    Text(language.englishName + (language.isUnofficial ? " · unofficial" : " · official"))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if language == settings.language {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.tint)
                                }
                            }
                        }
                    }
                } header: {
                    Text(Loc.t("settings.language", lang))
                } footer: {
                    Text(Loc.t("settings.language_footer", lang))
                }
            }
            .navigationTitle(Loc.t("settings.title", lang))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(Loc.t("done", lang)) { dismiss() }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppSettings())
}
