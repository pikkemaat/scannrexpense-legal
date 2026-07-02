import SwiftUI
import SwiftData

/// Fill in the spider web: one page per dimension, each aspect scored 0–10,
/// followed by a reflection page. There is no norm — it is a personal
/// evaluation of this moment, and a conversation starter.
struct QuestionnaireView: View {
    let version: ToolVersion

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettings.self) private var settings

    @State private var scores: [String: Double] = [:]
    @State private var reflection: String = ""
    @State private var pageIndex: Int = 0
    @State private var includeFrom12 = true
    @State private var savedAssessment: Assessment?

    private var lang: AppLanguage { settings.language }
    private var dimensions: [Dimension] { version.dimensions }
    private var lastPage: Int { dimensions.count }
    private var hasFrom12Aspects: Bool {
        dimensions.contains { $0.aspects.contains { $0.from12Years } }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ProgressView(value: Double(pageIndex + 1), total: Double(lastPage + 1))
                    .padding(.horizontal)

                TabView(selection: $pageIndex) {
                    ForEach(Array(dimensions.enumerated()), id: \.element.id) { index, dimension in
                        dimensionPage(dimension)
                            .tag(index)
                    }
                    reflectionPage
                        .tag(lastPage)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                navigationButtons
            }
            .navigationTitle(version.title(lang))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Loc.t("cancel", lang)) { dismiss() }
                }
            }
            .navigationDestination(item: $savedAssessment) { assessment in
                ResultView(assessment: assessment, onDone: { dismiss() })
            }
        }
        .interactiveDismissDisabled()
    }

    private func aspects(of dimension: Dimension) -> [Aspect] {
        dimension.aspects.filter { includeFrom12 || !$0.from12Years }
    }

    private func dimensionPage(_ dimension: Dimension) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 12) {
                    Image(systemName: dimension.symbolName)
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(dimension.color, in: Circle())
                    VStack(alignment: .leading) {
                        Text(Loc.name(dimension, lang))
                            .font(.title3.bold())
                            .foregroundStyle(dimension.color)
                        Text(Loc.t("q.how_feel", lang))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if version == .child && dimension.id == dimensions.first?.id && hasFrom12Aspects {
                    Toggle(Loc.t("q.include12", lang), isOn: $includeFrom12)
                        .font(.subheadline)
                        .padding(12)
                        .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
                }

                ForEach(aspects(of: dimension)) { aspect in
                    aspectRow(aspect, color: dimension.color)
                }
            }
            .padding()
        }
    }

    private func aspectRow(_ aspect: Aspect, color: Color) -> some View {
        let binding = Binding<Double>(
            get: { scores[aspect.id] ?? 5 },
            set: { scores[aspect.id] = $0 }
        )
        return VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(Loc.text(aspect, lang))
                    .font(.subheadline.weight(.medium))
                Spacer()
                Text(emoji(for: binding.wrappedValue))
                Text("\(Int(binding.wrappedValue))")
                    .font(.subheadline.monospacedDigit().bold())
                    .foregroundStyle(color)
                    .frame(minWidth: 24, alignment: .trailing)
            }
            Slider(value: binding, in: 0...10, step: 1)
                .tint(color)
        }
        .padding(12)
        .background(.quaternary.opacity(0.4), in: RoundedRectangle(cornerRadius: 12))
    }

    private var reflectionPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(Loc.t("q.almost_done", lang))
                    .font(.title3.bold())
                Text(version.reflectionPrompt(lang))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                TextField(Loc.t("q.write_here", lang), text: $reflection, axis: .vertical)
                    .lineLimit(4...8)
                    .textFieldStyle(.roundedBorder)

                Text(Loc.t("q.save_footer", lang))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }

    private var navigationButtons: some View {
        HStack {
            if pageIndex > 0 {
                Button {
                    withAnimation { pageIndex -= 1 }
                } label: {
                    Label(Loc.t("back", lang), systemImage: "chevron.left")
                }
                .buttonStyle(.bordered)
            }
            Spacer()
            if pageIndex < lastPage {
                Button {
                    withAnimation { pageIndex += 1 }
                } label: {
                    Label(Loc.t("next", lang), systemImage: "chevron.right")
                        .labelStyle(.titleAndIcon)
                }
                .buttonStyle(.borderedProminent)
            } else {
                Button {
                    save()
                } label: {
                    Label(Loc.t("q.show_web", lang), systemImage: "checkmark")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }

    private func save() {
        // Fill in the default for anything the user did not touch, so the
        // stored assessment is complete and unambiguous.
        var complete = scores
        for dimension in dimensions {
            for aspect in aspects(of: dimension) where complete[aspect.id] == nil {
                complete[aspect.id] = 5
            }
        }
        let assessment = Assessment(version: version, scores: complete, reflection: reflection)
        modelContext.insert(assessment)
        savedAssessment = assessment
    }

    private func emoji(for value: Double) -> String {
        switch value {
        case ..<2: return "😞"
        case ..<4: return "🙁"
        case ..<6: return "😐"
        case ..<8: return "🙂"
        default: return "😄"
        }
    }
}

#Preview {
    QuestionnaireView(version: .adolescent)
        .environment(AppSettings())
        .modelContainer(for: Assessment.self, inMemory: true)
}
