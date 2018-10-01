import Vapor
import Foundation

public struct Localization: Codable {

    public typealias Section = String
    public typealias Key = String
    public typealias Translation = String
    public typealias LocalizationFormat = [Section: [Key: Translation]]

//    let application: Application
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

    func isOutdated() -> Bool {

        let cacheInMinutes = 99
        let cacheInSeconds: TimeInterval = Double(cacheInMinutes) * 60
        let expirationDate: Date = self.date.addingTimeInterval(cacheInSeconds)
//        application.connectionManager.logger.log("Expiration of current cache is: \(expirationDate), current time is: \(Date())")

        return (expirationDate.compare(Date()) == .orderedAscending)
    }

    func get(section: Section, key: Key) -> Translation {

        guard let translation = translations[section]?[key] else {

//            application.connectionManager.logger.log("No translation found for section '\(section)' and key '\(key)'")
            return Localization.fallback(section: section, key: key)
        }
        return translation
    }

    public static func fallback(section: Section, key: Key) -> Translation {
        return section + "." + key
    }
}
