import Vapor

internal final class NStackLogger {

    internal let config: NStack.Config

    internal init(config: NStack.Config) {
        self.config = config
    }

    internal func log(_ message: String) {
        if self.config.log {
            debugPrint("[NStack] \(message)")
        }
    }
}

extension NStackLogger: ServiceType {

    public static func makeService(for container: Container) throws -> Self {
        let config = try container.make(NStack.Config.self)
        return self.init(config: config)
    }
}
