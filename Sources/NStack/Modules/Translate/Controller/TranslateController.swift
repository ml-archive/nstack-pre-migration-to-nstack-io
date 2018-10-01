import Vapor
import Foundation

public final class TranslateController {

    let application: Application
    let config: Translate.Config
    var localizations: [String: Localization] = [:]
    var attempts: [String: TranslationAttempt] = [:]

    internal var cache: KeyedCache { get { return self.application.cache }}

    public enum Platform: String, Codable {
        case backend, api, web, mobile
    }

    internal init(application: Application, config: Translate.Config) {
        self.application = application
        self.config = config
    }

    public final func get(
        on worker: Worker,
        platform: Platform? = nil,
        language: String? = nil,
        section: String,
        key: String,
        searchReplacePairs: [String: String]? = nil
    ) -> Future<String> {

        let platform = platform ?? self.config.defaultPlatform
        let language = language ?? self.config.defaultLanguage

        application.connectionManager.logger.log("Requesting translate for platform: \(platform) - language: \(language) - section: \(section) - key: \(key)")

        do {

            return try fetchLocalization(
                on: worker,
                platform: platform,
                language: language
            ).map { localization in

                if let localization = localization {

                    var value = localization.get(section: section, key: key)

                    // Search / Replace placeholders
                    if let searchReplacePairs = searchReplacePairs {
                        for(search, replace) in searchReplacePairs {
                            value = value.replacingOccurrences(of: self.config.placeholderPrefix + search + self.config.placeholderSuffix, with: replace)
                        }
                    }
                    return value

                } else {
                    return Localization.fallback(section: section, key: key)
                }
            }

        } catch {

            return worker.future(Localization.fallback(section: section, key: key))
        }
    }

    private final func fetchLocalization(
        on worker: Worker,
        platform: Platform,
        language: String
    ) throws -> Future<Localization?> {

        let cacheKey = TranslateController.cacheKey(platform: platform, language: language)

        // Look up attempt
        if let attempt: TranslationAttempt = attempts[cacheKey], attempt.avoidFetchingAgain() {
            application.connectionManager.logger.log("Failed lately, no reason to try again")

            // Try vapor cache
            return freshFromCache(
                on: worker,
                platform: platform,
                language: language
            ).map { localization in

                if let _ = localization {
                    self.application.connectionManager.logger.log("Vapor cache used as fallback")
                } else {
                    self.application.connectionManager.logger.log("Failed lately and no cache")
                }
                return localization
            }
        }

        // Try memory cache
        if let memoryLocalization = freshFromMemory(platform: platform, language: language) {
            application.connectionManager.logger.log("Memory cache used")
            return worker.future(memoryLocalization)
        }

        // Try vapor cache
        return freshFromCache(
            on: worker,
            platform: platform,
            language: language
        ).flatMap { cachedLocalization in

            if let cachedLocalization = cachedLocalization {
                self.application.connectionManager.logger.log("Vapor cache used as fallback")
                return worker.future(cachedLocalization)
            }

            // Fetch from API
            do {
                return try self.application.connectionManager.getTranslation(

                    application: self.application,
                    platform: platform,
                    language: language
                ).flatMap { localization in
                    return self.setCache(localization: localization).map{}
                        .transform(to: localization)
                }
            } catch {
                self.attempts[TranslateController.cacheKey(platform: platform, language: language)] = try TranslationAttempt(error: error)
                throw error
            }
        }
    }

    private final func freshFromMemory(platform: Platform, language: String) -> Localization?
    {
        let cacheKey = "\(TranslateController.cacheKey(platform: platform, language: language))"

        // Look up in memory
        guard let localization: Localization = localizations[cacheKey] else {
            return nil
        }

        // If outdated remove
        if localization.isOutdated() {
            localizations.removeValue(forKey: cacheKey)
            return nil
        }

        return localization
    }

    private final func freshFromCache(
        on worker: Worker,
        platform: Platform,
        language: String
    ) -> Future<Localization?> {

        let cacheKey = TranslateController.cacheKey(platform: platform, language: language)

        return cache.get(cacheKey, as: Localization.self).map { localization in

            if let localization = localization, localization.isOutdated() {
                self.application.connectionManager.logger.log("Droplet cache is outdated removing it")
                _ = self.cache.remove(cacheKey)
                return nil
            }
            return localization
        }
    }

    private final func setCache(localization: Localization) -> Future<Void> {

        let cacheKey = TranslateController.cacheKey(
            platform: localization.platform,
            language: localization.language
        )
        application.connectionManager.logger.log("Caching translate on key: \(cacheKey)")

        // Put in memory cache
        localizations[cacheKey] = localization

        // Put in vapor KeyedCache
        return cache.set(cacheKey, to: localization).map{}
    }

    private static func cacheKey(platform: Platform, language: String) -> String {
        return platform.rawValue.lowercased() + "_" + language.lowercased()
    }
}
