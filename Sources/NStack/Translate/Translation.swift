import Vapor
import Foundation
import Cache
import Sugar

public struct Translation {
    
    let drop: Droplet
    let application: Application
    let json: JSON
    let platform: String
    let language: String
    let date: Date
    
    init(drop: Droplet, application: Application, json: JSON, platform: String, language: String) {
        self.drop = drop
        self.application = application
        self.json = json
        self.platform = platform
        self.language = language
        
        self.date = Date()
    }
    
    init(drop: Droplet, application: Application, node: Node) throws {
        self.drop = drop
        self.application = application
        
        self.json = try node.get("json")
        self.platform = try node.get("platform")
        self.language = try node.get("language")
    
        self.date = try Date.parse(.dateTime, node.get("date"), Date())
    }
    
    func isOutdated() -> Bool {
        let cacheInMinutes = drop.config["nstack", "translate", "cacheInMinutes"]?.int ?? 60

        let secondsInMinutes: TimeInterval = Double(cacheInMinutes) * 60
        
        let dateAtCacheExpiration: Date = self.date.addingTimeInterval(secondsInMinutes)
        do {
            try application.nStackConfig.log("Expiration of current cache is: " + dateAtCacheExpiration.toDateTimeString() + " current time is: " + Date().toDateTimeString())
        } catch {}
        
        return dateAtCacheExpiration.isPast()
    }
    
    func get(section: String, key: String) -> String {
        do {
            let data: Node = try self.json.get("data")
            
            let sectionNode: Node = try data.get(section)
            
            let key: String = try sectionNode.get(key)
            return key
        } catch  {
            
            application.nStackConfig.log("NStack.Translate.get error:" + error.localizedDescription)
            return Translation.fallback(section: section, key: key)
        }
    }
    
    public static func fallback(section: String, key: String) -> String{
        return section + "." + key
    }
    
    func toNode() throws -> Node{
        return Node([
            "language": Node(language),
            "platform": Node(platform),
            "json": Node(json),
            "date": try Node(date.toDateTimeString())
        ])
    }
}
