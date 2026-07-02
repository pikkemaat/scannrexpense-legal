import Foundation

// Explanatory content about Positive Health, summarised in our own words from
// the public information of Positive Health International
// (www.positivehealth-international.com) and the Institute for Positive Health
// (www.iph.nl/en). The dialogue-tool wording itself lives in
// PositiveHealthContent.swift and is reproduced verbatim from the official tools.
enum LearnContent {

    // MARK: What is Positive Health?

    static let whatIsIt = """
    Positive Health is a broad view of health that was developed in the \
    Netherlands. Instead of defining health as the absence of disease, it looks \
    at people as whole persons: at their resilience — the ability to deal with \
    the physical, emotional and social challenges of life — and at what makes \
    their life meaningful. The central question shifts from "What is the matter \
    with you?" to "What matters to you?"

    It is not a treatment or a test. It is a way of looking, a reflection tool \
    and a conversation starter that helps you stay in charge of your own life \
    wherever possible.
    """

    static let huberQuote = "I am convinced that of all forces that enhance health, meaningfulness is the strongest."
    static let huberQuoteAuthor = "Machteld Huber, founder of Positive Health"

    // MARK: Origin & science

    static let origin = """
    Positive Health was initiated by Machteld Huber, a former Dutch general \
    practitioner and researcher. After falling seriously ill herself, she \
    noticed how much her own attitude and sense of direction influenced her \
    recovery — something the prevailing view of health had no room for.

    The World Health Organization's 1948 definition describes health as a state \
    of complete physical, mental and social well-being. Huber and her \
    colleagues argued in the British Medical Journal (2011) that this ideal of \
    "complete well-being" is static and unattainable — by that standard almost \
    nobody is healthy, least of all people living with a chronic condition. \
    They proposed a dynamic alternative: health as the ability to adapt and to \
    self-manage in the face of life's challenges.

    To find out what health means to people themselves, Huber's team then \
    interviewed patients, care professionals and researchers. The hundreds of \
    health indicators that came out of this study were grouped into six main \
    dimensions — the six axes of the spider web. The research also builds on \
    older insights: Aaron Antonovsky's salutogenesis (studying what creates \
    health rather than what causes disease) and the Blue Zones, regions where \
    people grow old in remarkably good health.
    """

    // MARK: The six dimensions, explained in one line each.
    // Keyed by Dimension.id prefix-free suffix (body/mind/meaning/quality/participation/daily).

    static let dimensionExplanations: [String: String] = [
        "body": "How your body feels and functions — feeling healthy and fit, sleeping, eating, moving, and being free of complaints or pain.",
        "mind": "Your inner life — remembering and concentrating, handling your feelings, accepting yourself and feeling in control.",
        "meaning": "Purpose and direction — a meaningful life, zest for life, ideals and dreams, confidence, acceptance and gratitude.",
        "quality": "How you experience your life — enjoyment, happiness, balance, safety, and circumstances such as housing and money.",
        "participation": "Your connection with others — social contacts, being taken seriously, belonging, support, and doing meaningful things together.",
        "daily": "Managing everyday life — taking care of yourself, work or study, knowing your limits, and being able to ask for help.",
    ]

    /// Explanation for a dimension, looked up by the suffix of its id
    /// (e.g. "adult.body" → "body").
    static func explanation(for dimension: Dimension) -> String? {
        guard let suffix = dimension.id.split(separator: ".").last else { return nil }
        return dimensionExplanations[String(suffix)]
    }

    // MARK: The spider web & the other conversation

    static let spiderWeb = """
    You fill in the questionnaire yourself, scoring each aspect from 0 to 10. \
    Your answers are drawn as your personal health surface in the spider web. \
    There is no norm and nothing to pass or fail: the web shows how you \
    experience your health at this moment, in all six dimensions — a picture \
    that is much richer than a single number.

    Filling it in is often an eye-opener in itself: health turns out to be not \
    only your body and your mood, but also meaning, participation, quality of \
    life and how you manage your days.
    """

    static let otherConversation = """
    The spider web is the starting point for what Positive Health calls "the \
    other conversation" — with a doctor, nurse, coach, social worker, or \
    someone you trust. The conversation first broadens (looking at the whole \
    web, not just one complaint) and then narrows down to what really matters \
    to you. It is not about the lowest scores; you choose what you want to \
    give attention.

    Such conversations regularly take surprising turns: the thing someone \
    first came in with turns out not to be the thing they most want to work \
    on. People usually already know what is needed — the web helps to say it \
    out loud.

    From there, the approach is deliberately small: pick one small step you \
    can take yourself, and think about who or what could support you. When \
    one point of the web moves, other points tend to move too.
    """

    // MARK: Who is it for & where is it used

    static let whoAndWhere = """
    The dialogue tools exist in three versions — for adults, for adolescents \
    and young adults, and for children — so everyone from about 8 years old \
    can fill in their own web. The official tools are published in more than \
    ten languages, and an online version is available at mypositivehealth.com.

    Positive Health started in the Netherlands and is now used \
    internationally, from GP practices and hospitals to schools, workplaces \
    and whole regions. It is applied on four levels: by individuals for \
    themselves, by professionals in their daily work, by communities, and in \
    the health system as a whole — as a driver of change from disease-oriented \
    to health-oriented care.
    """

    // MARK: Source & disclaimer

    static let sourceNote = """
    The dialogue tool content in this app (dimensions, aspects and \
    conversation questions) is © iPH/PHi, reproduced from the official \
    English tools of Positive Health International in collaboration with the \
    institute for Positive Health (iPH). The explanatory texts on this page \
    summarise the public information of both organisations.

    This app is a companion for personal use. It is not a medical device and \
    does not provide diagnoses or medical advice. Your answers are stored \
    only on this device.
    """
}
