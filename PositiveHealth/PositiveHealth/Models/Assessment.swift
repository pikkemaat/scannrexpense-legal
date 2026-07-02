import Foundation
import SwiftData

@Model
final class Assessment {
    var date: Date
    var versionRaw: String
    var scoresData: Data
    var reflection: String
    var answerAttention: String
    var answerStep: String
    var answerSupport: String

    init(version: ToolVersion, scores: [String: Double], reflection: String = "") {
        self.date = Date()
        self.versionRaw = version.rawValue
        self.scoresData = (try? JSONEncoder().encode(scores)) ?? Data()
        self.reflection = reflection
        self.answerAttention = ""
        self.answerStep = ""
        self.answerSupport = ""
    }

    var version: ToolVersion { ToolVersion(rawValue: versionRaw) ?? .adult }

    var scores: [String: Double] {
        get { (try? JSONDecoder().decode([String: Double].self, from: scoresData)) ?? [:] }
        set { scoresData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }

    /// Average score of the answered aspects of one dimension, or nil if none were answered.
    func average(for dimension: Dimension) -> Double? {
        let values = dimension.aspects.compactMap { scores[$0.id] }
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }

    /// One value per dimension, in the order of the tool, for the spider web.
    var dimensionValues: [Double] {
        version.dimensions.map { average(for: $0) ?? 0 }
    }

    var overallAverage: Double {
        let averages = version.dimensions.compactMap { average(for: $0) }
        guard !averages.isEmpty else { return 0 }
        return averages.reduce(0, +) / Double(averages.count)
    }
}
