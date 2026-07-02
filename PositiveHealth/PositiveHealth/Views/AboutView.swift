import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("What is Positive Health?") {
                    Text("Positive Health is a broad view of health, developed in the Netherlands from research by Machteld Huber. Instead of asking what is the matter with you, it asks what matters to you. From interviews about what health means to people, around 500 indicators were grouped into six main dimensions — together they form the spider web.")
                        .font(.subheadline)
                }

                Section("The six dimensions") {
                    ForEach(ToolVersion.adult.dimensions) { dimension in
                        HStack(spacing: 12) {
                            Image(systemName: dimension.symbolName)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                                .background(dimension.color, in: Circle())
                            Text(dimension.name)
                                .font(.subheadline)
                        }
                    }
                }

                Section("How it works — three steps") {
                    step(number: 1, title: "Fill in the spider web",
                         text: "Score how you feel about each aspect, from 0 to 10. It only takes a few minutes. There is no norm — it is a personal evaluation of this moment.")
                    step(number: 2, title: "Have the other conversation",
                         text: "Use your spider web as a conversation starter — with a doctor, nurse, social worker, coach, or a friend. Not about where scores are low, but about where you want to go and what is important to you.")
                    step(number: 3, title: "Take a small step",
                         text: "Choose one small step you can take yourself, and think about who or what could support you. When one point of the web moves, other points move too.")
                }

                Section("Versions") {
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
                } header: {
                    Text("Learn more")
                } footer: {
                    Text("The dialogue tool content is © iPH/PHi, reproduced from the official English tools of Positive Health International in collaboration with the institute for Positive Health (iPH). This app is a companion for personal use and is not a medical device; it does not provide diagnoses or medical advice.")
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
