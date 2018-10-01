public extension Translate {

    public struct Config: Codable {

        public let defaultPlatform: Translate.Platform
        public let defaultLanguage: String
        public let cacheInMinutes: Int

        public static let `default` = Translate.Config(
            defaultPlatform: .backend,
            defaultLanguage: "en-EN",
            cacheInMinutes: 60
        )

        public init(
            defaultPlatform: Translate.Platform = Translate.Config.default.defaultPlatform,
            defaultLanguage: String = Translate.Config.default.defaultLanguage,
            cacheInMinutes: Int =  Translate.Config.default.cacheInMinutes
            ) {
            self.defaultPlatform = defaultPlatform
            self.defaultLanguage = defaultLanguage
            self.cacheInMinutes = cacheInMinutes
        }
    }

}
