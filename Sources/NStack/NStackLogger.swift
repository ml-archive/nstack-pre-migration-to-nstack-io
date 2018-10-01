import Vapor

internal final class NStackLogger {

    internal let config: NStack.Config

    init(config: NStack.Config) {
        self.config = config
    }

    internal func log(_ message: String) {
        if self.config.log {
            debugPrint("[NStack] \(message)")
        }
    }
}

extension NStackLogger: ServiceType {

    public static func makeService(for worker: Container) throws -> Self {
        let config = try worker.make(NStack.Config.self)
        return self.init(config: config)
    }
}
