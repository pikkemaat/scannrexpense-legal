import SwiftUI
import SwiftData

/// The personal health overview: the spider web, the scores per dimension and
/// the questions for "the other conversation".
struct ResultView: View {
    @Bindable var assessment: Assessment
    /// Set when shown right after filling in the questionnaire; called by the
    /// Done button to close the whole questionnaire sheet.
    var onDone: (() -> Void)? = nil

    @Query(sort: \Assessment.date, order: .reverse) private var allAssessments: [Assessment]
    @State private var compareWithPrevious = false

    private var previousAssessment: Assessment? {
        allAssessments.first {
            $0.versionRaw == assessment.versionRaw && $0.date < assessment.date
        }
    }

    var body: some View {
        List {
            Section {
                SpiderWebView(
                    dimensions: assessment.version.dimensions,
                    values: assessment.dimensionValues,
                    comparisonValues: compareWithPrevious ? previousAssessment?.dimensionValues : nil
                )
                .padding(.vertical, 8)
                .listRowSeparator(.hidden)

                if let previous = previousAssessment {
                    Toggle(isOn: $compareWithPrevious.animation()) {
                        VStack(alignment: .leading) {
                            Text("Compare with previous")
                            Text(previous.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } header: {
                Text("\(assessment.version.title) · \(assessment.date.formatted(date: .abbreviated, time: .shortened))")
            } footer: {
                Text("There is no norm and no score to reach. This is your own picture of this moment.")
            }

            Section("My dimensions") {
                ForEach(assessment.version.dimensions) { dimension in
                    dimensionRow(dimension)
                }
            }

            if !assessment.reflection.isEmpty {
                Section(assessment.version.reflectionPrompt) {
                    Text(assessment.reflection)
                }
            }

            Section {
                conversationField(
                    question: PositiveHealthContent.conversationQuestions[0].question,
                    text: $assessment.answerAttention
                )
                conversationField(
                    question: PositiveHealthContent.conversationQuestions[1].question,
                    text: $assessment.answerStep
                )
                conversationField(
                    question: PositiveHealthContent.conversationQuestions[2].question,
                    text: $assessment.answerSupport
                )
            } header: {
                Text("The other conversation")
            } footer: {
                Text("It doesn't matter where you start — what matters is that you start, and that you take small steps. When one point moves, other points move too.")
            }
        }
        .navigationTitle("My Positive Health")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(onDone != nil)
        .toolbar {
            if let onDone {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { onDone() }
                }
            }
        }
    }

    private func dimensionRow(_ dimension: Dimension) -> some View {
        DisclosureGroup {
            ForEach(dimension.aspects.filter { assessment.scores[$0.id] != nil }) { aspect in
                HStack {
                    Text(aspect.text)
                        .font(.subheadline)
                    Spacer()
                    Text("\(Int(assessment.scores[aspect.id] ?? 0))")
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: dimension.symbolName)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .frame(width: 30, height: 30)
                    .background(dimension.color, in: Circle())
                Text(dimension.name)
                    .font(.subheadline.weight(.medium))
                Spacer()
                if let average = assessment.average(for: dimension) {
                    Text(average.formatted(.number.precision(.fractionLength(1))))
                        .font(.subheadline.monospacedDigit().bold())
                        .foregroundStyle(dimension.color)
                }
            }
        }
    }

    private func conversationField(question: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(question)
                .font(.subheadline.weight(.medium))
            TextField("Your answer…", text: text, axis: .vertical)
                .lineLimit(2...5)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        ResultView(assessment: Assessment(
            version: .adolescent,
            scores: Dictionary(uniqueKeysWithValues: ToolVersion.adolescent.dimensions
                .flatMap(\.aspects)
                .map { ($0.id, Double(Int.random(in: 3...9))) }),
            reflection: "My friends and my music."
        ))
    }
    .modelContainer(for: Assessment.self, inMemory: true)
}
