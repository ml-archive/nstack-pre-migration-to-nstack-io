import Vapor

public final class NStackPreloadMiddleware: Middleware {
    
    public func respond(
        to request: Request,
        chainingTo next: Responder
    ) throws -> Future<Response> {
        
        guard let nstack = try? request.make(NStack.self) else {
            print("NStack has not been registered.")
            return try next.respond(to: request)
        }
        
        return try nstack.application.translate.preloadLocalization(on: request).flatMap { _ in
            return try next.respond(to: request)
        }.catchFlatMap { error in
            try? request.make(NStackLogger.self).log("NStack error: \(error)")
            return try next.respond(to: request)
        }
    }
}

extension NStackPreloadMiddleware: ServiceType {
    public static func makeService(for container: Container) throws -> NStackPreloadMiddleware {
        return .init()
    }
}
