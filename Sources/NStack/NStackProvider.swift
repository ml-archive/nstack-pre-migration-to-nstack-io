import Vapor
import Leaf

public final class NStackProvider {

    internal let config: NStack.Config
    internal let cacheFactory: ((Container) throws -> KeyedCache)
    
    public init(
        config: NStack.Config,
        cacheFactory: @escaping ((Container) throws -> KeyedCache) = { container in try container.make() }
    ) {
        self.config = config
        self.cacheFactory = cacheFactory
    }
}

extension NStackProvider: Provider {
    
    public func register(_ services: inout Services) throws {
        try services.register(LeafProvider())
        services.register(config)
        services.register(NStackLogger.self)
        services.register { container -> NStack in
            
            return try NStack(
                on: container,
                cacheFactory: self.cacheFactory
            )
        }
        services.register(NStackPreloadMiddleware.self)
    }

    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
}

public extension LeafTagConfig {
    mutating func useNStackLeafTags(_ container: Container) throws {
        let nstack = try container.make(NStack.self)
        use(TranslateTag(nstack: nstack), as: "nstack:translate")
    }
}
