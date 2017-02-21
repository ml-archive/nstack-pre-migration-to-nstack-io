import Vapor
import Foundation
import Cache

public class TranslationAttempt {
    
    public var dates: [String: Error] = [:]
    
    init(error: Error) throws {
        try append(error: error)
    }
    
    public func append(error: Error) throws {
        let dateString = try Date().toDateTimeString()
        
        dates[dateString] = error
    }
    
    public func avoidFetchingAgain() -> Bool {
        let datePreRetryPeriod = Date().addingTimeInterval(-3 * 60)
        let datePreNotFoundPeriod =  Date().addingTimeInterval(-5 * 60)
        
        for (key, value) in dates {
            do {
            let date = Date.parse(.dateTime, key, Date())
                
                // Any errors within few secs should give a break in trying again
                if date.isAfter(datePreRetryPeriod) {
                    return true
                }
                
                // Not found errors within few min should give a break in trying again
                if date.isAfter(datePreNotFoundPeriod) && value.localizedDescription.equals(any: "notFound") {
                    return true
                }
            } catch {
                // Do nothing
            }
        }
        
        return false
    }
}
