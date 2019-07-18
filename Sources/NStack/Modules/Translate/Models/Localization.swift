import Vapor
import Foundation

struct Localization: Codable {

    typealias Section = String
    typealias Key = String
    typealias Translation = String
    typealias LocalizationFormat = [Section: [Key: Translation]]

    let translations: LocalizationFormat
    let platform: Translate.Platform
    let language: String
    let date: Date

    init(
        responseData: ResponseData,
        platform: Translate.Platform,
        language: String
    ) {
        self.translations = responseData.translations
        self.platform = platform
        self.language = language
        self.date = Date()
    }

    func isOutdated(on worker: Container, _ cacheInMinutes: Int) -> Bool {

        let cacheInSeconds: TimeInterval = Double(cacheInMinutes) * 60
        let expirationDate: Date = self.date.addingTimeInterval(cacheInSeconds)

        try? worker.make(NStackLogger.self).log("Expiration of current cache is: \(expirationDate), current time is: \(Date())")
        return (expirationDate.compare(Date()) == .orderedAscending)
    }

    func get(on worker: Container, section: Section, key: Key) -> Translation {

        guard let translation = translations[section]?[key] else {

            try? worker.make(NStackLogger.self).log("No translation found for section '\(section)' and key '\(key)'")
            return Localization.fallback(section: section, key: key)
        }
        return translation
    }

    func get(on worker: Container, section: Section) -> [Key: Translation] {

        guard let sectionTranslations = translations[section] else {

            try? worker.make(NStackLogger.self).log("No translation found for section '\(section)'")
            return Localization.fallback(section: section)
        }
        return sectionTranslations
    }

    static func fallback(section: Section, key: Key) -> Translation {
        return section + "." + key
    }

    static func fallback(section: Section) -> [Key: Translation] {
        return [Key: Translation]()
    }
}
