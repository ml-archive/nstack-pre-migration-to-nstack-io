import TLS
import Vapor

public final class NStackProvider: Vapor.Provider {
    public static var repositoryName: String = "NStack"

    let nstack: NStack

    public func boot(_ drop: Droplet) throws {
        nstack.connectionManager.client = try drop.config.resolveClient()
            .makeClient(
                hostname: ConnectionManager.baseUrl,
                port: 443,
                securityLayer: .tls(Context(.client))
        )
        nstack.connectionManager.cache = try drop.config.resolveCache()

        drop.nstack = nstack
    }

    public func boot(_ config: Vapor.Config) throws {}

    public init(config: Vapor.Config) throws {
        nstack = try NStack(config: config)
    }
    
    public func beforeRun(_: Droplet) {}
}
