import Vapor

public final class NStackProvider {

    internal let config: NStack.Config

    public init(config: NStack.Config) {
        self.config = config
    }

    public func register(_ services: inout Services) throws {
        services.register(config)
        services.register(NStackLogger.self)
        services.register(NStack.self)
    }
}

extension NStackProvider: Provider {

    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
}
