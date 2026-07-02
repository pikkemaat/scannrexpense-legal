import Foundation

/// Unofficial translations for every language other than English, keyed by the
/// same keys as `Loc.english` plus the dialogue-tool content ids
/// (`Dimension.id`, `Aspect.id`, `conv.<id>`, `dimexpl.<suffix>`).
///
/// Anything missing for a language falls back to the English source, so partial
/// tables are safe. These are generated for this app and are NOT the official
/// wording of the Positive Health tools.
enum TranslationTables {
    static let tables: [AppLanguage: [String: String]] = [
        .de: German.table,
        .nl: Dutch.table,
        .da: Danish.table,
        .no: Norwegian.table,
        .ja: Japanese.table,
        .isl: Icelandic.table,
        .es: Spanish.table,
        .fr: French.table,
        .it: Italian.table,
        .pap: Papiamento.table,
        .hu: Hungarian.table,
    ]
}
