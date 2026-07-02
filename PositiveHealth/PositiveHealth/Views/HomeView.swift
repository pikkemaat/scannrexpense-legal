import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Assessment.date, order: .reverse) private var assessments: [Assessment]

    @State private var newVersion: ToolVersion?
    @State private var showAbout = false

    var body: some View {
        NavigationStack {
            Group {
                if assessments.isEmpty {
                    emptyState
                } else {
                    assessmentList
                }
            }
            .navigationTitle("My Positive Health")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showAbout = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    newAssessmentMenu
                }
            }
            .sheet(item: $newVersion) { version in
                QuestionnaireView(version: version)
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
        }
    }

    private var newAssessmentMenu: some View {
        Menu {
            ForEach(ToolVersion.allCases) { version in
                Button {
                    newVersion = version
                } label: {
                    Label("\(version.title) (\(version.ageRange))", systemImage: "square.and.pencil")
                }
            }
        } label: {
            Label("Fill in the spider web", systemImage: "plus")
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("Fill in your spider web", systemImage: "hexagon")
        } description: {
            Text("Positive Health looks at what matters to you, across six dimensions of health. Fill in the spider web to get your personal overview — a starting point for a different conversation.")
        } actions: {
            newAssessmentMenu
                .buttonStyle(.borderedProminent)
        }
    }

    private var assessmentList: some View {
        List {
            ForEach(assessments) { assessment in
                NavigationLink {
                    ResultView(assessment: assessment)
                } label: {
                    row(for: assessment)
                }
            }
            .onDelete(perform: delete)
        }
    }

    private func row(for assessment: Assessment) -> some View {
        HStack(spacing: 14) {
            SpiderWebView(dimensions: assessment.version.dimensions,
                          values: assessment.dimensionValues,
                          showLabels: false)
                .frame(width: 52, height: 52)
            VStack(alignment: .leading, spacing: 2) {
                Text(assessment.version.title)
                    .font(.headline)
                Text(assessment.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(assessment.overallAverage.formatted(.number.precision(.fractionLength(1))))
                .font(.subheadline.monospacedDigit().bold())
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(assessments[index])
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Assessment.self, inMemory: true)
}
