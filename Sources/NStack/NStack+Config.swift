import Vapor

public extension NStack {

    public struct Config: Service {

        public let applicationConfigs: [Application.Config]
        public let defaultApplicationName: String
        public let defaultTranslateConfig: Translate.Config
        public let log: Bool
        public let baseURL: String

        public init(
            applicationConfigs: [Application.Config],
            defaultApplicationName: String? = nil,
            defaultTranslateConfig: Translate.Config = Translate.Config.default,
            log: Bool = false,
            baseURL: String = "https://nstack.io/api/v1/"
            ) {
            self.applicationConfigs = applicationConfigs
            self.defaultApplicationName = defaultApplicationName ?? applicationConfigs[0].name
            self.defaultTranslateConfig = defaultTranslateConfig
            self.log = log
            self.baseURL = baseURL
        }
    }

}
