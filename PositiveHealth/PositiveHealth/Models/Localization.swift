import SwiftUI
import Observation

/// The languages the app is offered in. These are the twelve languages in which
/// the official Positive Health dialogue tools are published. English uses the
/// official verbatim wording; all other languages are UNOFFICIAL translations
/// made for this app (see `unofficialTranslationNote`).
enum AppLanguage: String, CaseIterable, Identifiable, Codable {
    case en, de, nl, da, no
    case ja, isl, es, fr, it, pap, hu

    var id: String { rawValue }

    /// The languages actually offered, in display order (English first, then
    /// the other eleven official tool languages).
    static var offered: [AppLanguage] { allCases }

    /// Endonym — the language's own name, shown in the picker.
    var endonym: String {
        switch self {
        case .en: return "English"
        case .de: return "Deutsch"
        case .nl: return "Nederlands"
        case .da: return "Dansk"
        case .no: return "Norsk"
        case .ja: return "日本語"
        case .isl: return "Íslenska"
        case .es: return "Español"
        case .fr: return "Français"
        case .it: return "Italiano"
        case .pap: return "Papiamentu"
        case .hu: return "Magyar"
        }
    }

    /// English name, shown as a subtitle in the picker.
    var englishName: String {
        switch self {
        case .en: return "English"
        case .de: return "German"
        case .nl: return "Dutch"
        case .da: return "Danish"
        case .no: return "Norwegian"
        case .ja: return "Japanese"
        case .isl: return "Icelandic"
        case .es: return "Spanish"
        case .fr: return "French"
        case .it: return "Italian"
        case .pap: return "Papiamento"
        case .hu: return "Hungarian"
        }
    }

    /// Whether the questionnaire/UI for this language is an unofficial
    /// translation (everything except English).
    var isUnofficial: Bool { self != .en }

    /// BCP-47 code used for date/number formatting.
    var localeIdentifier: String {
        switch self {
        case .en: return "en"
        case .de: return "de"
        case .nl: return "nl"
        case .da: return "da"
        case .no: return "nb"
        case .ja: return "ja"
        case .isl: return "is"
        case .es: return "es"
        case .fr: return "fr"
        case .it: return "it"
        case .pap: return "pap"
        case .hu: return "hu"
        }
    }

    var locale: Locale { Locale(identifier: localeIdentifier) }

    /// Best match for the user's system language on first launch.
    static var systemDefault: AppLanguage {
        let codes = Locale.preferredLanguages.map { Locale(identifier: $0).language.languageCode?.identifier ?? "" }
        for code in codes {
            if let match = offered.first(where: { $0.localeIdentifier.hasPrefix(code) || code == $0.localeIdentifier }) {
                return match
            }
        }
        return .en
    }
}

/// App-wide, persisted settings. Injected into the environment so views can
/// react to a language change live, without relaunching.
@Observable
final class AppSettings {
    var language: AppLanguage {
        didSet { UserDefaults.standard.set(language.rawValue, forKey: Self.key) }
    }

    private static let key = "appLanguage"

    init() {
        if let raw = UserDefaults.standard.string(forKey: Self.key),
           let stored = AppLanguage(rawValue: raw), AppLanguage.offered.contains(stored) {
            language = stored
        } else {
            language = AppLanguage.systemDefault
        }
    }
}

/// Central lookup for every translatable string in the app.
///
/// One flat key space covers UI text, the explanatory "learn" content and the
/// dialogue-tool content (dimension names keyed by `Dimension.id`, aspects by
/// `Aspect.id`, conversation questions by their id). English is authored here;
/// all other languages come from `TranslationTables.tables` (unofficial).
enum Loc {

    /// Translate a UI/learn key. Falls back to English, then to the key itself.
    static func t(_ key: String, _ language: AppLanguage) -> String {
        if language != .en, let v = TranslationTables.tables[language]?[key] { return v }
        return english[key] ?? key
    }

    /// Localized dimension name (falls back to the English name on the model).
    static func name(_ dimension: Dimension, _ language: AppLanguage) -> String {
        if language != .en, let v = TranslationTables.tables[language]?[dimension.id] { return v }
        return dimension.name
    }

    /// Localized aspect text (falls back to the English text on the model).
    static func text(_ aspect: Aspect, _ language: AppLanguage) -> String {
        if language != .en, let v = TranslationTables.tables[language]?[aspect.id] { return v }
        return aspect.text
    }

    /// Localized conversation question (falls back to the English question).
    static func question(_ item: (id: String, question: String), _ language: AppLanguage) -> String {
        if language != .en, let v = TranslationTables.tables[language]?["conv." + item.id] { return v }
        return item.question
    }

    static let unofficialTranslationNote =
        "This language is an unofficial translation made for this app. The official Positive Health dialogue tools are published by iPH/PHi; only the English wording here is the official verbatim text."

    /// English source strings for all UI and learn keys.
    static let english: [String: String] = [
        // Generic
        "done": "Done",
        "cancel": "Cancel",
        "back": "Back",
        "next": "Next",

        // Home
        "app_title": "My Positive Health",
        "fill_menu": "Fill in the spider web",
        "empty_title": "Fill in your spider web",
        "empty_desc": "Positive Health looks at what matters to you, across six dimensions of health. Fill in the spider web to get your personal overview — a starting point for a different conversation.",

        // Tool versions
        "version.adult.title": "Adults",
        "version.adolescent.title": "Adolescents / young adults",
        "version.child.title": "Children",
        "version.adult.age": "18+ years",
        "version.adolescent.age": "16–25 years",
        "version.child.age": "8–16 years",
        "reflect.adult": "Something that is important to me is missing:",
        "reflect.adolescent": "The following is particularly important to me",
        "reflect.child": "The following is particularly important to me",

        // Questionnaire
        "q.how_feel": "How do you feel about this? There are no right or wrong answers.",
        "q.include12": "Include questions for 12 years and older",
        "q.almost_done": "Almost done",
        "q.write_here": "Write it down here…",
        "q.save_footer": "When you save, your personal overview appears in the spider web. Remember: this is not a test and there is no norm — it is your own picture of this moment, and a starting point for a conversation.",
        "q.show_web": "Show my spider web",

        // Result
        "r.compare": "Compare with previous",
        "r.no_norm_footer": "There is no norm and no score to reach. This is your own picture of this moment.",
        "r.my_dimensions": "My dimensions",
        "r.other_conversation": "The other conversation",
        "r.other_footer": "It doesn't matter where you start — what matters is that you start, and that you take small steps. When one point moves, other points move too.",
        "r.your_answer": "Your answer…",
        "conv.attention": "Is there something you would like to give more attention, or would like to change?",
        "conv.step": "What small step could you take yourself?",
        "conv.support": "Who or what could support you with this?",

        // Settings
        "settings.title": "Settings",
        "settings.language": "Language",
        "settings.language_footer": "English uses the official wording of the Positive Health tools. The other languages are unofficial translations made for this app.",

        // About — section titles
        "about.title": "About Positive Health",
        "about.s.whatisit": "What is Positive Health?",
        "about.s.origin": "Where does it come from?",
        "about.s.dimensions": "The six dimensions",
        "about.s.spiderweb": "The spider web",
        "about.s.conversation": "The other conversation",
        "about.s.steps": "How it works — three steps",
        "about.s.who": "Who is it for?",
        "about.s.movement": "A movement, not just a tool",
        "about.s.value": "The value it aims for",
        "about.s.resources": "More resources",
        "about.s.versions": "Versions in this app",
        "about.s.learnmore": "Learn more",

        // About — body
        "about.whatisit": "Positive Health is a broad view of health that was developed in the Netherlands. Instead of defining health as the absence of disease, it looks at people as whole persons: at their resilience — the ability to deal with the physical, emotional and social challenges of life — and at what makes their life meaningful. The central question shifts from “What is the matter with you?” to “What matters to you?”\n\nIt is not a treatment or a test. It is a way of looking, a reflection tool and a conversation starter that helps you stay in charge of your own life wherever possible.",
        "about.quote": "I am convinced that of all forces that enhance health, meaningfulness is the strongest.",
        "about.quote_author": "Machteld Huber, founder of Positive Health",
        "about.origin": "Positive Health was initiated by Machteld Huber, a former Dutch general practitioner and researcher. After falling seriously ill herself, she noticed how much her own attitude and sense of direction influenced her recovery — something the prevailing view of health had no room for.\n\nThe World Health Organization's 1948 definition describes health as a state of complete physical, mental and social well-being. Huber and her colleagues argued in the British Medical Journal (2011) that this ideal of “complete well-being” is static and unattainable — by that standard almost nobody is healthy, least of all people living with a chronic condition. They proposed a dynamic alternative: health as the ability to adapt and to self-manage in the face of life's challenges.\n\nTo find out what health means to people themselves, Huber's team then interviewed patients, care professionals and researchers. The hundreds of health indicators that came out of this study were grouped into six main dimensions — the six axes of the spider web. The research also builds on older insights: Aaron Antonovsky's salutogenesis (studying what creates health rather than what causes disease) and the Blue Zones, regions where people grow old in remarkably good health.",
        "about.spiderweb": "You fill in the questionnaire yourself, scoring each aspect from 0 to 10. Your answers are drawn as your personal health surface in the spider web. There is no norm and nothing to pass or fail: the web shows how you experience your health at this moment, in all six dimensions — a picture that is much richer than a single number.\n\nFilling it in is often an eye-opener in itself: health turns out to be not only your body and your mood, but also meaning, participation, quality of life and how you manage your days.",
        "about.conversation": "The spider web is the starting point for what Positive Health calls “the other conversation” — with a doctor, nurse, coach, social worker, or someone you trust. The conversation first broadens (looking at the whole web, not just one complaint) and then narrows down to what really matters to you. It is not about the lowest scores; you choose what you want to give attention.\n\nSuch conversations regularly take surprising turns: the thing someone first came in with turns out not to be the thing they most want to work on. People usually already know what is needed — the web helps to say it out loud.\n\nFrom there, the approach is deliberately small: pick one small step you can take yourself, and think about who or what could support you. When one point of the web moves, other points tend to move too.",
        "about.step1.title": "Fill in the spider web",
        "about.step1.text": "Score how you feel about each aspect, from 0 to 10. It only takes a few minutes. There is no norm — it is a personal evaluation of this moment.",
        "about.step2.title": "Have the other conversation",
        "about.step2.text": "Use your spider web as a conversation starter — with a doctor, nurse, social worker, coach, or a friend. Not about where scores are low, but about where you want to go and what is important to you.",
        "about.step3.title": "Take a small step",
        "about.step3.text": "Choose one small step you can take yourself, and think about who or what could support you. When one point of the web moves, other points move too.",
        "about.who": "The dialogue tools exist in three versions — for adults, for adolescents and young adults, and for children — so everyone from about 8 years old can fill in their own web. The official tools are published in more than ten languages, and an online version is available at mypositivehealth.com.\n\nPositive Health started in the Netherlands and is now used internationally, from GP practices and hospitals to schools, workplaces and whole regions. It is applied on four levels: by individuals for themselves, by professionals in their daily work, by communities, and in the health system as a whole — as a driver of change from disease-oriented to health-oriented care.",
        "about.movement": "Positive Health is not only a tool but a movement — a different way of thinking, doing, organising and financing care. It usually starts with a few committed people and local partners who share a vision, and grows into broader coalitions. The way it is implemented differs per country and culture, but the core vision stays the same. It has taken root across many domains in the Netherlands over the past decade and is now spreading internationally.\n\nAt its heart is a shift away from “the repair reflex” — the automatic urge to fix a complaint — towards empowering people to recognise what they themselves can do to live a purposeful, meaningful life.",
        "about.value": "In care, Positive Health aims at what is known as the “Quadruple Aim”:\n\n• Improving the health of the population\n• Improving people's experience of care\n• Reducing costs\n• Improving the wellbeing of care teams and professionals\n\nTogether these describe a move from disease-oriented care to health-oriented care — care that starts from what matters to a person, not only from what is wrong with them.",
        "about.resources": "Beyond the spider web, Positive Health International and the institute for Positive Health (iPH) offer more ways to go deeper:\n\n• The online spider web at mypositivehealth.com, for filling it in digitally.\n• An e-learning module, “The Essence of Positive Health”, as an introduction.\n• A handbook with comprehensive guidance.\n• Free downloads and materials for people and professionals.\n\nThis app is an independent personal companion that lets you fill in the spider web on your device; the resources above are the source and the place to learn more.",
        "about.link.phi": "Positive Health International — dialogue tools",
        "about.link.iph": "Institute for Positive Health (iPH)",
        "about.link.online": "My Positive Health — official online spider web",
        "about.source": "The dialogue tool content in this app (dimensions, aspects and conversation questions) is © iPH/PHi. The English wording is reproduced from the official English tools of Positive Health International in collaboration with the institute for Positive Health (iPH). Translations into other languages are unofficial and were made for this app. The explanatory texts summarise the public information of both organisations.\n\nThis app is a companion for personal use. It is not a medical device and does not provide diagnoses or medical advice. Your answers are stored only on this device.",

        // Dimension explanations (keyed by dimension suffix)
        "dimexpl.body": "How your body feels and functions — feeling healthy and fit, sleeping, eating, moving, and being free of complaints or pain.",
        "dimexpl.mind": "Your inner life — remembering and concentrating, handling your feelings, accepting yourself and feeling in control.",
        "dimexpl.meaning": "Purpose and direction — a meaningful life, zest for life, ideals and dreams, confidence, acceptance and gratitude.",
        "dimexpl.quality": "How you experience your life — enjoyment, happiness, balance, safety, and circumstances such as housing and money.",
        "dimexpl.participation": "Your connection with others — social contacts, being taken seriously, belonging, support, and doing meaningful things together.",
        "dimexpl.daily": "Managing everyday life — taking care of yourself, work or study, knowing your limits, and being able to ask for help.",
    ]

    /// Localized one-line explanation for a dimension (by its id suffix).
    static func explanation(_ dimension: Dimension, _ language: AppLanguage) -> String? {
        guard let suffix = dimension.id.split(separator: ".").last else { return nil }
        let key = "dimexpl." + suffix
        if language != .en, let v = TranslationTables.tables[language]?[key] { return v }
        return english[key]
    }
}

// Language-aware accessors for the tool version. The English strings match the
// official wording; other languages come from the (unofficial) translation
// tables. `toolName` stays untranslated — those are the tools' proper names.
extension ToolVersion {
    func title(_ language: AppLanguage) -> String { Loc.t("version.\(rawValue).title", language) }
    func ageRange(_ language: AppLanguage) -> String { Loc.t("version.\(rawValue).age", language) }
    func reflectionPrompt(_ language: AppLanguage) -> String { Loc.t("reflect.\(rawValue)", language) }
}
