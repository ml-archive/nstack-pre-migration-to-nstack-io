import Vapor
import Sugar

public final class NStackProvider {

    internal let config: NStack.Config

    public init(config: NStack.Config) {
        self.config = config
    }
}

extension NStackProvider: Provider {

    public func register(_ services: inout Services) throws {
        try services.register(MutableLeafTagConfigProvider())
        services.register(config)
        services.register(NStackLogger.self)
        services.register(NStack.self)
    }

    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        let nstack = try container.make(NStack.self)
        let tags = try container.make(MutableLeafTagConfig.self)
        tags.use(TranslateTag(nstack: nstack), as: "nstack:translate")
        return .done(on: container)
    }
}
