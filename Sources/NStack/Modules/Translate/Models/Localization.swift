import Vapor
import Foundation

internal struct Localization: Codable {

    internal typealias Section = String
    internal typealias Key = String
    internal typealias Translation = String
    internal typealias LocalizationFormat = [Section: [Key: Translation]]

    internal let translations: LocalizationFormat
    internal let platform: Translate.Platform
    internal let language: String
    internal let date: Date

    internal init(
        responseData: ResponseData,
        platform: Translate.Platform,
        language: String
    ) {
        self.translations = responseData.translations
        self.platform = platform
        self.language = language
        self.date = Date()
    }

    internal func isOutdated(on worker: Container, _ cacheInMinutes: Int) -> Bool {

        let cacheInSeconds: TimeInterval = Double(cacheInMinutes) * 60
        let expirationDate: Date = self.date.addingTimeInterval(cacheInSeconds)

        try? worker.make(NStackLogger.self).log("Expiration of current cache is: \(expirationDate), current time is: \(Date())")
        return (expirationDate.compare(Date()) == .orderedAscending)
    }

    internal func get(on worker: Container, section: Section, key: Key) -> Translation {

        guard let translation = translations[section]?[key] else {

            try? worker.make(NStackLogger.self).log("No translation found for section '\(section)' and key '\(key)'")
            return Localization.fallback(section: section, key: key)
        }
        return translation
    }

    internal static func fallback(section: Section, key: Key) -> Translation {
        return section + "." + key
    }
}
