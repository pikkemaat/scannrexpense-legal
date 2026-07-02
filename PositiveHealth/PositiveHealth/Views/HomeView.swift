import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettings.self) private var settings
    @Query(sort: \Assessment.date, order: .reverse) private var assessments: [Assessment]

    @State private var newVersion: ToolVersion?
    @State private var showAbout = false
    @State private var showSettings = false

    private var lang: AppLanguage { settings.language }

    var body: some View {
        NavigationStack {
            Group {
                if assessments.isEmpty {
                    emptyState
                } else {
                    assessmentList
                }
            }
            .navigationTitle(Loc.t("app_title", lang))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showAbout = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "globe")
                    }
                    newAssessmentMenu
                }
            }
            .sheet(item: $newVersion) { version in
                QuestionnaireView(version: version)
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }

    private var newAssessmentMenu: some View {
        Menu {
            ForEach(ToolVersion.allCases) { version in
                Button {
                    newVersion = version
                } label: {
                    Label("\(version.title(lang)) (\(version.ageRange(lang)))", systemImage: "square.and.pencil")
                }
            }
        } label: {
            Label(Loc.t("fill_menu", lang), systemImage: "plus")
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label(Loc.t("empty_title", lang), systemImage: "hexagon")
        } description: {
            Text(Loc.t("empty_desc", lang))
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
                Text(assessment.version.title(lang))
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
        .environment(AppSettings())
        .modelContainer(for: Assessment.self, inMemory: true)
}
