import SwiftUI

struct AboutView: View {
    @Environment(AppSettings.self) private var settings
    @Environment(\.dismiss) private var dismiss

    private var lang: AppLanguage { settings.language }

    var body: some View {
        NavigationStack {
            List {
                Section(Loc.t("about.s.whatisit", lang)) {
                    Text(Loc.t("about.whatisit", lang))
                        .font(.subheadline)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("“\(Loc.t("about.quote", lang))”")
                            .font(.subheadline.italic())
                        Text("— \(Loc.t("about.quote_author", lang))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }

                Section(Loc.t("about.s.origin", lang)) {
                    Text(Loc.t("about.origin", lang))
                        .font(.subheadline)
                }

                Section(Loc.t("about.s.dimensions", lang)) {
                    ForEach(ToolVersion.adult.dimensions) { dimension in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: dimension.symbolName)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                                .background(dimension.color, in: Circle())
                            VStack(alignment: .leading, spacing: 2) {
                                Text(Loc.name(dimension, lang))
                                    .font(.subheadline.weight(.medium))
                                if let explanation = Loc.explanation(dimension, lang) {
                                    Text(explanation)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }

                Section(Loc.t("about.s.spiderweb", lang)) {
                    Text(Loc.t("about.spiderweb", lang))
                        .font(.subheadline)
                }

                Section(Loc.t("about.s.conversation", lang)) {
                    Text(Loc.t("about.conversation", lang))
                        .font(.subheadline)
                }

                Section(Loc.t("about.s.steps", lang)) {
                    step(1, "about.step1.title", "about.step1.text")
                    step(2, "about.step2.title", "about.step2.text")
                    step(3, "about.step3.title", "about.step3.text")
                }

                Section(Loc.t("about.s.who", lang)) {
                    Text(Loc.t("about.who", lang))
                        .font(.subheadline)
                }

                Section(Loc.t("about.s.movement", lang)) {
                    Text(Loc.t("about.movement", lang))
                        .font(.subheadline)
                }

                Section(Loc.t("about.s.value", lang)) {
                    Text(Loc.t("about.value", lang))
                        .font(.subheadline)
                }

                Section(Loc.t("about.s.resources", lang)) {
                    Text(Loc.t("about.resources", lang))
                        .font(.subheadline)
                }

                Section(Loc.t("about.s.versions", lang)) {
                    ForEach(ToolVersion.allCases) { version in
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(version.title(lang)) · \(version.ageRange(lang))")
                                .font(.subheadline.weight(.medium))
                            Text(version.toolName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section {
                    Link(destination: URL(string: "https://positivehealth-international.com/dialogue-tools/")!) {
                        Label(Loc.t("about.link.phi", lang), systemImage: "globe")
                    }
                    Link(destination: URL(string: "https://www.iph.nl/en/")!) {
                        Label(Loc.t("about.link.iph", lang), systemImage: "globe")
                    }
                    Link(destination: URL(string: "https://www.mypositivehealth.com/")!) {
                        Label(Loc.t("about.link.online", lang), systemImage: "globe")
                    }
                } header: {
                    Text(Loc.t("about.s.learnmore", lang))
                } footer: {
                    Text(Loc.t("about.source", lang))
                }
            }
            .navigationTitle(Loc.t("about.title", lang))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(Loc.t("done", lang)) { dismiss() }
                }
            }
        }
    }

    private func step(_ number: Int, _ titleKey: String, _ textKey: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(Loc.t(titleKey, lang), systemImage: "\(number).circle.fill")
                .font(.subheadline.weight(.semibold))
            Text(Loc.t(textKey, lang))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    AboutView()
        .environment(AppSettings())
}
