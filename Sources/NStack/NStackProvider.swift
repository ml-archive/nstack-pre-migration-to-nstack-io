import Vapor

public final class NStackProvider {

    public let config: NStackConfig

    public init(config: NStackConfig) {
        self.config = config
    }

    public func register(_ services: inout Services) throws {
        services.register(config)
        services.register(NStack.self)
    }
}

extension NStackProvider: Provider {

    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
}
