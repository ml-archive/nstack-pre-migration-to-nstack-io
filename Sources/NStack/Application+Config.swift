public extension Application {

    public struct Config: Codable {

        public let name: String
        public let applicationId: String
        public let restKey: String
        public let masterKey: String

        public init(
            name: String,
            applicationId: String,
            restKey: String,
            masterKey: String
        ) {
            self.name = name
            self.applicationId = applicationId
            self.restKey = restKey
            self.masterKey = masterKey
        }
    }
}
