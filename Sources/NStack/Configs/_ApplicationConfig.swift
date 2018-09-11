import Vapor

struct ApplicationConfig {
    
    enum ConfigError: String {
        case name = "name"
        case applicationId = "applicationId"
        case restKey = "restKey"
        case masterKey = "masterKey"
        
        var error: Abort {
            return Abort(
                .internalServerError,
                metadata: nil,
                reason: "NStack error - nstack.applications[].\(rawValue) config is missing."
            )
        }
    }
    
    let name: String
    let applicationId: String
    let restKey: String
    let masterKey: String
    
    init(config: Config) throws {
        
        // Set name
        guard let name: String = config["name"]?.string else {
            throw ConfigError.name.error
        }
        self.name = name;
        
        // Set applicationId
        guard let applicationId: String = config["applicationId"]?.string else {
            throw ConfigError.applicationId.error
        }
        self.applicationId = applicationId;
        
        // Set restKey
        guard let restKey: String = config["restKey"]?.string else {
            throw ConfigError.restKey.error
        }
        self.restKey = restKey;
        
        // Set masterKey
        guard let masterKey: String = config["masterKey"]?.string else {
            throw ConfigError.masterKey.error
        }
        self.masterKey = masterKey;
    }
}
