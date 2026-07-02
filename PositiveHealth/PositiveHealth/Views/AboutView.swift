import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("What is Positive Health?") {
                    Text(LearnContent.whatIsIt)
                        .font(.subheadline)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("“\(LearnContent.huberQuote)”")
                            .font(.subheadline.italic())
                        Text("— \(LearnContent.huberQuoteAuthor)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }

                Section("Where does it come from?") {
                    Text(LearnContent.origin)
                        .font(.subheadline)
                }

                Section("The six dimensions") {
                    ForEach(ToolVersion.adult.dimensions) { dimension in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: dimension.symbolName)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                                .background(dimension.color, in: Circle())
                            VStack(alignment: .leading, spacing: 2) {
                                Text(dimension.name)
                                    .font(.subheadline.weight(.medium))
                                if let explanation = LearnContent.explanation(for: dimension) {
                                    Text(explanation)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }

                Section("The spider web") {
                    Text(LearnContent.spiderWeb)
                        .font(.subheadline)
                }

                Section("The other conversation") {
                    Text(LearnContent.otherConversation)
                        .font(.subheadline)
                }

                Section("How it works — three steps") {
                    step(number: 1, title: "Fill in the spider web",
                         text: "Score how you feel about each aspect, from 0 to 10. It only takes a few minutes. There is no norm — it is a personal evaluation of this moment.")
                    step(number: 2, title: "Have the other conversation",
                         text: "Use your spider web as a conversation starter — with a doctor, nurse, social worker, coach, or a friend. Not about where scores are low, but about where you want to go and what is important to you.")
                    step(number: 3, title: "Take a small step",
                         text: "Choose one small step you can take yourself, and think about who or what could support you. When one point of the web moves, other points move too.")
                }

                Section("Who is it for?") {
                    Text(LearnContent.whoAndWhere)
                        .font(.subheadline)
                }

                Section("A movement, not just a tool") {
                    Text(LearnContent.movement)
                        .font(.subheadline)
                }

                Section("The value it aims for") {
                    Text(LearnContent.value)
                        .font(.subheadline)
                }

                Section("More resources") {
                    Text(LearnContent.resources)
                        .font(.subheadline)
                }

                Section("Versions in this app") {
                    ForEach(ToolVersion.allCases) { version in
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(version.title) · \(version.ageRange)")
                                .font(.subheadline.weight(.medium))
                            Text(version.toolName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section {
                    Link(destination: URL(string: "https://positivehealth-international.com/dialogue-tools/")!) {
                        Label("Positive Health International — dialogue tools", systemImage: "globe")
                    }
                    Link(destination: URL(string: "https://www.iph.nl/en/")!) {
                        Label("Institute for Positive Health (iPH)", systemImage: "globe")
                    }
                    Link(destination: URL(string: "https://www.mypositivehealth.com/")!) {
                        Label("My Positive Health — official online spider web", systemImage: "globe")
                    }
                } header: {
                    Text("Learn more")
                } footer: {
                    Text(LearnContent.sourceNote)
                }
            }
            .navigationTitle("About Positive Health")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func step(number: Int, title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(title, systemImage: "\(number).circle.fill")
                .font(.subheadline.weight(.semibold))
            Text(text)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    AboutView()
}
