import Vapor
import Cache
public struct Application{
    // Basic
    var cache: CacheProtocol? {
        return connectionManager.cache
    }
    let connectionManager: ConnectionManager
    let applicationConfig: ApplicationConfig
    let nStackConfig: NStackConfig
    
    // Features
    public lazy var translate: Translate = Translate(application: self)
    public lazy var content: Content = Content(application: self)
    
    // Keys
    let name: String
    let applicationId: String
    let restKey: String
    let masterKey: String
    
    init(connectionManager: ConnectionManager, applicationConfig: ApplicationConfig, nStackConfig: NStackConfig){
        self.connectionManager = connectionManager
        self.applicationConfig = applicationConfig
        self.nStackConfig = nStackConfig
        
        self.name = applicationConfig.name
        self.applicationId = applicationConfig.applicationId
        self.restKey = applicationConfig.restKey
        self.masterKey = applicationConfig.masterKey
    }
}
