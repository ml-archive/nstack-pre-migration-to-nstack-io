import Vapor
import Foundation
import Cache

public final class NStack {
    public let connectionManager: ConnectionManager
    public let config: NStackConfig
    public let cache: CacheProtocol
    var defaultApplication: Application
    
    public let applications: [Application]
    public var application: Application
    
    public init(config: NStackConfig, connectionManager: ConnectionManager, cache: CacheProtocol) throws {
        self.config = config
        self.connectionManager = connectionManager
        self.cache = cache
        
        // Set applications
        var applications: [Application] = []
        for applicationConfig in self.config.applications {
            applications.append(Application(cache: cache, connectionManager: connectionManager, applicationConfig: applicationConfig, nStackConfig: config))
        }
        
        self.applications = applications
        
        // Set first application
        guard let app: Application = applications.first else {
            throw Abort.serverError
        }
        
        self.application = app
        self.defaultApplication = app
        
        // Set picked application
        self.defaultApplication = try setApplication(name: config.defaultApplication)
    }
    
    public convenience init(config: Config) throws {
        let nStackConfig = try NStackConfig(config: config)
        let connectionManager = try ConnectionManager(translateConfig: nStackConfig.translate, clientFactory: config.resolveClient())
        let cache = try config.resolveCache()

        try self.init(config: nStackConfig, connectionManager: connectionManager, cache: cache)
    }
    
    public func setApplication(name: String) throws -> Application {
        for application in applications {
            if(application.name == name) {
                self.application = application
                
                return self.application
            }
        }
        
        throw Abort(
            .internalServerError,
            metadata: nil,
            reason: "NStack - Application \(name) was not found"
        )
    }
    
    public func setApplicationToDefault() -> Application {
        self.application = self.defaultApplication
        
        return application
    }
    
    
}
