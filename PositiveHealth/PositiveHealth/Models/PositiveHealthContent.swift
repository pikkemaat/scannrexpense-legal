import SwiftUI

// Content of the My Positive Health dialogue tools.
// Source: © iPH/PHi dialogue tools (Adults 2.0, Adolescents and young adults 1.1,
// Children's tool 1.1), www.positivehealth-international.com, in collaboration
// with the institute for Positive Health (iPH). The wording of dimensions and
// aspects is reproduced verbatim from the official English tools.

enum ToolVersion: String, Codable, CaseIterable, Identifiable {
    case adult
    case adolescent
    case child

    var id: String { rawValue }

    var title: String {
        switch self {
        case .adult: return "Adults"
        case .adolescent: return "Adolescents / young adults"
        case .child: return "Children"
        }
    }

    var ageRange: String {
        switch self {
        case .adult: return "18+ years"
        case .adolescent: return "16–25 years"
        case .child: return "8–16 years"
        }
    }

    var toolName: String {
        switch self {
        case .adult: return "Dialogue tool 2.0"
        case .adolescent: return "Tool Adolescents and young adults 1.1"
        case .child: return "Children's tool 1.1"
        }
    }

    var reflectionPrompt: String {
        switch self {
        case .adult: return "Something that is important to me is missing:"
        case .adolescent, .child: return "The following is particularly important to me"
        }
    }

    var dimensions: [Dimension] { PositiveHealthContent.dimensions[self] ?? [] }
}

struct Dimension: Identifiable, Hashable {
    let id: String
    let name: String
    let symbolName: String
    let colorRed: Double
    let colorGreen: Double
    let colorBlue: Double
    let aspects: [Aspect]

    var color: Color { Color(red: colorRed, green: colorGreen, blue: colorBlue) }
}

struct Aspect: Identifiable, Hashable {
    let id: String
    let text: String
    /// Marked * in the children's tool: suitable for children from 12 years.
    let from12Years: Bool

    init(_ id: String, _ text: String, from12Years: Bool = false) {
        self.id = id
        self.text = text
        self.from12Years = from12Years
    }
}

enum PositiveHealthContent {

    // Official dimension colours of the My Positive Health spider web.
    private static let red = (0.85, 0.11, 0.16)      // body / bodily functions
    private static let blue = (0.16, 0.62, 0.83)     // feelings / mental well-being
    private static let purple = (0.53, 0.27, 0.60)   // meaningfulness / now and in the future
    private static let orange = (0.95, 0.61, 0.07)   // quality of life / feeling good about yourself
    private static let rust = (0.89, 0.38, 0.09)     // participation
    private static let green = (0.58, 0.76, 0.22)    // daily life / daily functioning

    static let dimensions: [ToolVersion: [Dimension]] = [
        .adult: [
            Dimension(id: "adult.body", name: "Bodily functions", symbolName: "figure.run",
                      colorRed: red.0, colorGreen: red.1, colorBlue: red.2, aspects: [
                Aspect("adult.body.1", "Feeling healthy"),
                Aspect("adult.body.2", "Feeling fit"),
                Aspect("adult.body.3", "No physical complaints or pain"),
                Aspect("adult.body.4", "Sleeping"),
                Aspect("adult.body.5", "Eating"),
                Aspect("adult.body.6", "Sexuality"),
                Aspect("adult.body.7", "Physical condition"),
                Aspect("adult.body.8", "Physical activity"),
            ]),
            Dimension(id: "adult.mind", name: "Mental well-being", symbolName: "brain.head.profile",
                      colorRed: blue.0, colorGreen: blue.1, colorBlue: blue.2, aspects: [
                Aspect("adult.mind.1", "Being able to remember things"),
                Aspect("adult.mind.2", "Being able to concentrate"),
                Aspect("adult.mind.3", "Being able to communicate"),
                Aspect("adult.mind.4", "Being cheerful"),
                Aspect("adult.mind.5", "Accepting yourself"),
                Aspect("adult.mind.6", "Being able to handle change"),
                Aspect("adult.mind.7", "Feeling in control"),
            ]),
            Dimension(id: "adult.meaning", name: "Meaningfulness", symbolName: "sparkles",
                      colorRed: purple.0, colorGreen: purple.1, colorBlue: purple.2, aspects: [
                Aspect("adult.meaning.1", "Having a meaningful life"),
                Aspect("adult.meaning.2", "Having a zest for life"),
                Aspect("adult.meaning.3", "Pursuing ideals"),
                Aspect("adult.meaning.4", "Feeling confident"),
                Aspect("adult.meaning.5", "Accepting life"),
                Aspect("adult.meaning.6", "Being grateful"),
                Aspect("adult.meaning.7", "Lifelong learning"),
            ]),
            Dimension(id: "adult.quality", name: "Quality of life", symbolName: "sun.max",
                      colorRed: orange.0, colorGreen: orange.1, colorBlue: orange.2, aspects: [
                Aspect("adult.quality.1", "Enjoyment"),
                Aspect("adult.quality.2", "Being happy"),
                Aspect("adult.quality.3", "Feeling good"),
                Aspect("adult.quality.4", "Feeling well-balanced"),
                Aspect("adult.quality.5", "Feeling safe"),
                Aspect("adult.quality.6", "Intimacy"),
                Aspect("adult.quality.7", "Housing circumstances"),
                Aspect("adult.quality.8", "Having enough money"),
            ]),
            Dimension(id: "adult.participation", name: "Participation", symbolName: "person.2",
                      colorRed: rust.0, colorGreen: rust.1, colorBlue: rust.2, aspects: [
                Aspect("adult.participation.1", "Social contacts"),
                Aspect("adult.participation.2", "Being taken seriously"),
                Aspect("adult.participation.3", "Doing fun things together"),
                Aspect("adult.participation.4", "Having the support from others"),
                Aspect("adult.participation.5", "Sense of belonging"),
                Aspect("adult.participation.6", "Doing meaningful things"),
                Aspect("adult.participation.7", "Being interested in society"),
            ]),
            Dimension(id: "adult.daily", name: "Daily functioning", symbolName: "list.bullet.clipboard",
                      colorRed: green.0, colorGreen: green.1, colorBlue: green.2, aspects: [
                Aspect("adult.daily.1", "Taking care of yourself"),
                Aspect("adult.daily.2", "Knowing your limitations"),
                Aspect("adult.daily.3", "Knowledge of health"),
                Aspect("adult.daily.4", "Managing time"),
                Aspect("adult.daily.5", "Managing money"),
                Aspect("adult.daily.6", "Being able to work"),
                Aspect("adult.daily.7", "Being able to ask for help"),
            ]),
        ],

        .adolescent: [
            Dimension(id: "adolescent.body", name: "My body", symbolName: "figure.run",
                      colorRed: red.0, colorGreen: red.1, colorBlue: red.2, aspects: [
                Aspect("adolescent.body.1", "Feeling healthy"),
                Aspect("adolescent.body.2", "Having energy"),
                Aspect("adolescent.body.3", "No physical complaints or pain"),
                Aspect("adolescent.body.4", "Eating healthily"),
                Aspect("adolescent.body.5", "Sleeping"),
                Aspect("adolescent.body.6", "Fitness"),
                Aspect("adolescent.body.7", "Sports & exercise"),
                Aspect("adolescent.body.8", "Physical appearance"),
            ]),
            Dimension(id: "adolescent.mind", name: "My feelings and thoughts", symbolName: "brain.head.profile",
                      colorRed: blue.0, colorGreen: blue.1, colorBlue: blue.2, aspects: [
                Aspect("adolescent.mind.1", "Concentration"),
                Aspect("adolescent.mind.2", "Managing your feelings"),
                Aspect("adolescent.mind.3", "Feeling positive about life"),
                Aspect("adolescent.mind.4", "Accepting yourself"),
                Aspect("adolescent.mind.5", "Confidence in yourself"),
                Aspect("adolescent.mind.6", "Dealing with change"),
                Aspect("adolescent.mind.7", "Being in control"),
            ]),
            Dimension(id: "adolescent.meaning", name: "Meaningfulness", symbolName: "sparkles",
                      colorRed: purple.0, colorGreen: purple.1, colorBlue: purple.2, aspects: [
                Aspect("adolescent.meaning.1", "Leading a meaningful life"),
                Aspect("adolescent.meaning.2", "Having confidence in the future"),
                Aspect("adolescent.meaning.3", "Having a zest for life"),
                Aspect("adolescent.meaning.4", "Having goals and dreams"),
                Aspect("adolescent.meaning.5", "Making choices"),
                Aspect("adolescent.meaning.6", "Accepting situations"),
                Aspect("adolescent.meaning.7", "Gratitude"),
            ]),
            Dimension(id: "adolescent.quality", name: "Quality of life", symbolName: "sun.max",
                      colorRed: orange.0, colorGreen: orange.1, colorBlue: orange.2, aspects: [
                Aspect("adolescent.quality.1", "Happiness"),
                Aspect("adolescent.quality.2", "Enjoyment"),
                Aspect("adolescent.quality.3", "Experience balance"),
                Aspect("adolescent.quality.4", "Feeling safe"),
                Aspect("adolescent.quality.5", "A pleasant environment"),
                Aspect("adolescent.quality.6", "Housing and living environment"),
                Aspect("adolescent.quality.7", "Making ends meet"),
            ]),
            Dimension(id: "adolescent.participation", name: "Participation", symbolName: "person.2",
                      colorRed: rust.0, colorGreen: rust.1, colorBlue: rust.2, aspects: [
                Aspect("adolescent.participation.1", "Social contacts"),
                Aspect("adolescent.participation.2", "Being taken seriously"),
                Aspect("adolescent.participation.3", "Doing fun things with other people"),
                Aspect("adolescent.participation.4", "Belonging"),
                Aspect("adolescent.participation.5", "Self-expression"),
                Aspect("adolescent.participation.6", "Meaningful relationships"),
                Aspect("adolescent.participation.7", "Receiving support and understanding from others"),
            ]),
            Dimension(id: "adolescent.daily", name: "Daily life", symbolName: "list.bullet.clipboard",
                      colorRed: green.0, colorGreen: green.1, colorBlue: green.2, aspects: [
                Aspect("adolescent.daily.1", "Taking care of yourself"),
                Aspect("adolescent.daily.2", "Being able to work or study"),
                Aspect("adolescent.daily.3", "Knowing your limitations"),
                Aspect("adolescent.daily.4", "Knowledge about health"),
                Aspect("adolescent.daily.5", "Ability to plan"),
                Aspect("adolescent.daily.6", "Being able to ask for help"),
                Aspect("adolescent.daily.7", "No smoking, alcohol or drugs"),
            ]),
        ],

        .child: [
            Dimension(id: "child.body", name: "My body", symbolName: "figure.run",
                      colorRed: red.0, colorGreen: red.1, colorBlue: red.2, aspects: [
                Aspect("child.body.1", "Feeling good"),
                Aspect("child.body.2", "Having energy"),
                Aspect("child.body.3", "Eating healthily"),
                Aspect("child.body.4", "Sleeping well"),
                Aspect("child.body.5", "Sports & exercise"),
                Aspect("child.body.6", "No physical complaints"),
                Aspect("child.body.7", "No pain"),
                Aspect("child.body.8", "Physical appearance"),
            ]),
            Dimension(id: "child.mind", name: "My feelings and thoughts", symbolName: "brain.head.profile",
                      colorRed: blue.0, colorGreen: blue.1, colorBlue: blue.2, aspects: [
                Aspect("child.mind.1", "Managing your feelings"),
                Aspect("child.mind.2", "Accepting yourself"),
                Aspect("child.mind.3", "Fitting in"),
                Aspect("child.mind.4", "Feeling positive about life", from12Years: true),
                Aspect("child.mind.5", "Knowing your limitations", from12Years: true),
                Aspect("child.mind.6", "Coping with adversity", from12Years: true),
            ]),
            Dimension(id: "child.meaning", name: "Now and in the future", symbolName: "sparkles",
                      colorRed: purple.0, colorGreen: purple.1, colorBlue: purple.2, aspects: [
                Aspect("child.meaning.1", "Looking at the future"),
                Aspect("child.meaning.2", "Culture and religion"),
                Aspect("child.meaning.3", "Having goals and dreams"),
                Aspect("child.meaning.4", "Making choices", from12Years: true),
                Aspect("child.meaning.5", "Self-knowledge"),
                Aspect("child.meaning.6", "Role models", from12Years: true),
            ]),
            Dimension(id: "child.quality", name: "Feeling good about yourself", symbolName: "sun.max",
                      colorRed: orange.0, colorGreen: orange.1, colorBlue: orange.2, aspects: [
                Aspect("child.quality.1", "Enjoyment"),
                Aspect("child.quality.2", "Happiness"),
                Aspect("child.quality.3", "Cheerfulness"),
                Aspect("child.quality.4", "A pleasant environment", from12Years: true),
                Aspect("child.quality.5", "Taking pleasure in doing things", from12Years: true),
                Aspect("child.quality.6", "Receiving support and understanding from others", from12Years: true),
            ]),
            Dimension(id: "child.participation", name: "Participation", symbolName: "person.2",
                      colorRed: rust.0, colorGreen: rust.1, colorBlue: rust.2, aspects: [
                Aspect("child.participation.1", "Friends"),
                Aspect("child.participation.2", "Belonging"),
                Aspect("child.participation.3", "Bullying"),
                Aspect("child.participation.4", "Self-determination", from12Years: true),
                Aspect("child.participation.5", "Keeping up with others", from12Years: true),
                Aspect("child.participation.6", "Personal contribution", from12Years: true),
            ]),
            Dimension(id: "child.daily", name: "Daily life", symbolName: "list.bullet.clipboard",
                      colorRed: green.0, colorGreen: green.1, colorBlue: green.2, aspects: [
                Aspect("child.daily.1", "Going to school"),
                Aspect("child.daily.2", "Being yourself"),
                Aspect("child.daily.3", "Leisure time"),
                Aspect("child.daily.4", "Looking after yourself"),
                Aspect("child.daily.5", "Feeling normal"),
                Aspect("child.daily.6", "Limitations"),
                Aspect("child.daily.7", "No smoking, alcohol or drug use", from12Years: true),
            ]),
        ],
    ]

    // Questions for "the other conversation" after filling in the spider web.
    static let conversationQuestions: [(id: String, question: String)] = [
        ("attention", "Is there something you would like to give more attention, or would like to change?"),
        ("step", "What small step could you take yourself?"),
        ("support", "Who or what could support you with this?"),
    ]
}
