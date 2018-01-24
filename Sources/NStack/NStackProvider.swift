import Vapor

public final class NStackProvider: Vapor.Provider {
    public static var repositoryName: String = "NStack"

    private let nStackConfig: NStackConfig

    public func boot(_ drop: Droplet) throws {
        let connectionManager = try ConnectionManager(
            cache: drop.cache,
            clientFactory: drop.client,
            nStackConfig: nStackConfig
        )

        drop.nstack = try NStack(
            config: nStackConfig,
            connectionManager: connectionManager
        )
    }

    public func boot(_ config: Config) throws {}

    public init(config: Config) throws {
        nStackConfig = try NStackConfig(config: config)
    }
    
    public func beforeRun(_: Droplet) {}
}
