import Vapor

public final class NStackProvider: Vapor.Provider {
    public static var repositoryName: String = "NStack"

    var nstack: NStack? = nil

    public func boot(_ drop: Droplet) {
        drop.nstack = nstack
    }

    public func boot(_ config: Config) throws {}

    public init(config: Config) throws {
        nstack = try NStack(config: config)
    }
    
    public func beforeRun(_: Droplet) {}
}
