public extension Application {

    struct Config: Codable {

        public let name: String
        public let applicationId: String
        public let restKey: String

        @available(*, deprecated, message: "Master Key is not needed and should not be included.")
        public var masterKey: String {
            return ""
        }

        @available(*, deprecated, message: "Use of Master Key is deprecated. Use init without it instead.")
        public init(
            name: String,
            applicationId: String,
            restKey: String,
            masterKey: String
        ) {
            self.name = name
            self.applicationId = applicationId
            self.restKey = restKey
        }

        public init(
            name: String,
            applicationId: String,
            restKey: String
        ) {
            self.name = name
            self.applicationId = applicationId
            self.restKey = restKey
        }
    }
}
