import Vapor

public final class NStackProvider: Vapor.Provider {
    public static var repositoryName: String = "NStack"

    var nstack: NStack? = nil
    
    
    public func boot(_ drop: Droplet) {
        drop.nstack = nstack
    }

    public func boot(_ config: Config) throws {}
    

    public init(drop: Droplet) throws {
        nstack = try NStack(drop: drop)
    }
    
    public init(config: Config) throws {
        // Don't use this init, it's only there cause of protocol
        throw Abort.serverError
    }
    
    
    // is automatically called directly after boot()
    public func afterInit(_ drop: Droplet) {
    }
    
    // is automatically called directly after afterInit()
    public func beforeRun(_: Droplet) {
    }
    
    public func beforeServe(_: Droplet) {
    }
}
