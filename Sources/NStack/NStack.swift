import Vapor
import Foundation
import Cache

public final class NStack {
    public let connectionManager: ConnectionMananger
    public let config: NStackConfig
    public let cache: CacheProtocol
    var defaultApplication: Application
    
    public let applications: [Application]
    public var application: Application
    
    public init(config: NStackConfig, connectionMananger: ConnectionMananger, cache: CacheProtocol) throws {
        self.config = config
        self.connectionManager = connectionMananger
        self.cache = cache
        
        // Set applications
        var applications: [Application] = []
        for applicaitonConfig in self.config.applications {
            applications.append(Application(cache: cache, connectionManager: connectionMananger, applicationConfig: applicaitonConfig, nStackConfig: config))
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
    
    public convenience init(drop: Droplet) throws {
        let nStackConfig = try NStackConfig(drop: drop)
        let connectionManager = ConnectionMananger(drop: drop)
        let cache = drop.cache
        
        try self.init(config: nStackConfig, connectionMananger: connectionManager, cache: cache)
    }
    
    public func setApplication(name: String) throws -> Application {
        for application in applications {
            if(application.name == name) {
                self.application = application
                
                return self.application
            }
        }
        
        throw Abort.custom(status: .internalServerError, message: "NStack - Application \(name) was not found")
    }
    
    public func setApplicationToDefault() -> Application {
        self.application = self.defaultApplication
        
        return application
    }
    
    
}
