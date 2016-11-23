import Vapor
public struct NStackConfig {
    enum ConfigError: String {
        case nstack = "nstack"
        case defaultApplication = "defaultApplication"
        case log = "log"
        case applications = "applications"
        
        var error: Abort {
            return .custom(status: .internalServerError,
                           message: "NStack error - nstack.\(rawValue) config is missing.")
        }
    }

    let log: Bool
    let defaultApplication: String
    let translate: TranslateConfig
    let applications: [ApplicationConfig]
    
    func log(_ value: String){
        if log {
            print(value)
        }
    }
    
    init(config: Config) throws {
        // set default application
        guard let defaultApplication: String = config["defaultApplication"]?.string else {
            throw ConfigError.defaultApplication.error
        }
        
        self.defaultApplication = defaultApplication
        
        // Set applications
        var applications: [ApplicationConfig] = []
        guard let applicationArr = config["applications"]?.array else {
            throw ConfigError.applications.error
        }
        
        // Set applications
        try applicationArr.forEach({
            try applications.append(ApplicationConfig(polymorphic: $0))
        })
        
        self.applications = applications
        
        // Set log
        guard let log = config["log"]?.bool else {
            throw ConfigError.log.error
        }
        self.log = log
        
        // Set translate
        self.translate = try TranslateConfig(optionalConfig: config["translate"])
    }
    
    init(drop: Droplet) throws {
        // Set config
        let optionalConfig = drop.config["nstack"]
        
        guard let config: Config = optionalConfig else {
            throw ConfigError.nstack.error
        }
        
        try self.init(config: config)
    }
    
  
}


