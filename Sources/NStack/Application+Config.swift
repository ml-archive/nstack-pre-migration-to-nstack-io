public extension Application {

    struct Config: Codable {

        public let name: String
        public let applicationId: String
        public let restKey: String

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
