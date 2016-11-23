import Vapor

struct TranslateConfig {
    enum ConfigError: String {
        case translate = "translate"
        case defaultPlatform = "defaultPlatform"
        case defaultLanguage = "defaultLanguage"
        case cacheInMinutes = "cacheInMinutes"
        
        var error: Abort {
            return .custom(status: .internalServerError,
                           message: "NStack error - nstack.translate.\(rawValue) config is missing.")
        }
    }
    
    let defaultPlatform: String
    let defaultLanguage: String
    let cacheInMinutes: Int
    
    init(optionalConfig: Config?) throws {
        guard let config: Config = optionalConfig else {
            throw ConfigError.translate.error
        }
        
        try self.init(config: config)
    }
    
    init(config: Config) throws {
        
        // Set default platform
        guard let defaultPlatform: String = config["defaultPlatform"]?.string else {
            throw ConfigError.defaultPlatform.error
        }
        self.defaultPlatform = defaultPlatform;
        
        // Set default language
        guard let defaultLanguage: String = config["defaultLanguage"]?.string else {
            throw ConfigError.defaultLanguage.error
        }
        self.defaultLanguage = defaultLanguage;
        
        // Set cache in minutes
        guard let cacheInMinutes: Int = config["cacheInMinutes"]?.int else {
            throw ConfigError.cacheInMinutes.error
        }
        self.cacheInMinutes = cacheInMinutes;
    }
}

/*
 public struct Configuration {
 
 public enum Field: String {
 case meta                   = "meta"
 case platforms              = "meta.platforms"
 case environments           = "meta.environments"
 case requiredEnvironments   = "meta.requiredEnvironments"
 case exceptPaths            = "meta.exceptPaths"
 
 var path: [String] {
 return rawValue.components(separatedBy: ".")
 }
 
 var error: Abort {
 return .custom(status: .internalServerError,
 message: "Meta error - \(rawValue) config is missing.")
 }
 }
 
 public let platforms: [String]
 public let environments: [String]
 public let requiredEnvironments: [String]
 public let exceptPaths: [String]
 
 public init(drop: Droplet) throws {
 self.platforms            = try Configuration.extract(drop: drop, field: .platforms)
 self.environments         = try Configuration.extract(drop: drop, field: .environments)
 self.requiredEnvironments = try Configuration.extract(drop: drop, field: .requiredEnvironments)
 self.exceptPaths          = try Configuration.extract(drop: drop, field: .exceptPaths)
 }
 
 private static func extract(drop: Droplet, field: Field) throws -> [String] {
 // Get array
 guard let platforms = drop.config[field.path]?.array else {
 throw field.error
 }
 
 // Get from config and make sure all values are strings
 return try platforms.map({
 guard let string = $0.string else {
 throw field.error
 }
 
 return string
 })
 }
 }
 Add Comment
 */
