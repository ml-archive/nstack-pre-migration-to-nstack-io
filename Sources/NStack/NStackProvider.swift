import Vapor
import Leaf

public final class NStackProvider {

    internal let config: NStack.Config

    public init(config: NStack.Config) {
        self.config = config
    }
}

extension NStackProvider: Provider {

    public func register(_ services: inout Services) throws {
        try services.register(LeafProvider())
        services.register(config)
        services.register(NStackLogger.self)
        services.register(NStack.self)
    }

    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
}

public extension LeafTagConfig {
    public mutating func useNStackLeafTags(_ container: Container) throws {
        let nstack = try container.make(NStack.self)
        var tags = try container.make(LeafTagConfig.self)
        tags.use(TranslateTag(nstack: nstack), as: "nstack:translate")
    }
}
