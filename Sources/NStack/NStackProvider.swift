import Vapor
import Leaf

public final class NStackProvider<C: KeyedCache> {

    internal let config: NStack.Config
    internal var cache: C? = nil
    
    public init(
        config: NStack.Config
    ) {
        self.config = config
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
                cache: self.cache
            )
        }
        services.register(NStackPreloadMiddleware.self)
    }

    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        
        self.cache = try container.make(C.self)
        return .done(on: container)
    }
}

public extension LeafTagConfig {
    public mutating func useNStackLeafTags(_ container: Container) throws {
        let nstack = try container.make(NStack.self)
        use(TranslateTag(nstack: nstack), as: "nstack:translate")
    }
}
