import Vapor

public extension Translate {

    public struct Config: Codable {

        public let defaultPlatform: Translate.Platform
        public let defaultLanguage: String
        public let cacheInMinutes: Int
        public let placeholderPrefix: String
        public let placeholderSuffix: String

        public static let `default` = Translate.Config(
            defaultPlatform: .backend,
            defaultLanguage: "en-EN",
            cacheInMinutes: 60,
            placeholderPrefix: "{",
            placeholderSuffix: "}"
        )

        public init(
            defaultPlatform: Translate.Platform = Translate.Config.default.defaultPlatform,
            defaultLanguage: String = Translate.Config.default.defaultLanguage,
            cacheInMinutes: Int =  Translate.Config.default.cacheInMinutes,
            placeholderPrefix: String = Translate.Config.default.placeholderPrefix,
            placeholderSuffix: String = Translate.Config.default.placeholderSuffix
        ) {
            self.defaultPlatform = defaultPlatform
            self.defaultLanguage = defaultLanguage
            self.cacheInMinutes = cacheInMinutes

            if placeholderPrefix.isEmpty || placeholderSuffix.isEmpty {
                debugPrint("placeholder prefix/suffix must not be empty, applying default ones")
                self.placeholderPrefix = Translate.Config.default.placeholderPrefix
                self.placeholderSuffix = Translate.Config.default.placeholderSuffix
            } else {
                self.placeholderPrefix = placeholderPrefix
                self.placeholderSuffix = placeholderSuffix
            }
        }
    }

}
