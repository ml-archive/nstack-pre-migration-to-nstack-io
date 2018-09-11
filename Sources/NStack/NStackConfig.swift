import Vapor

public struct NStackConfig: Service {

    public let log: Bool = false
    public let translate: Translate = Translate()
    public let applications: [Application]
    public let defaultApplication: Application
    public let baseURL: URL = URL(string: "https://nstack.io/api/v1/")!
}

extension NStackConfig {

    public struct Application: Codable {

        let name: String
        let applicationId: String
        let restKey: String
        let masterKey: String
    }

    public struct Translate: Codable {

        public let defaultPlatform: String = "backend"
        public let defaultLanguage: String = "en-EN"
        public let cacheInMinutes: Int = 60
    }
}
