import Vapor
import Foundation
import SwiftDate
import Cache

public class TranslationAttempt {
    
    public var dates: [String: Error] = [:]
    
    init(error: Error) {
        
        append(error: error)
    }
    
    public func append(error: Error) {
        let dateString = DateInRegion.init().string(format: .iso8601(options: .withInternetDateTime))
        
        dates[dateString] = error
    }
    
    public func avoidFetchingAgain() -> Bool {
        let datePreRetryPeriod = DateInRegion.init() - 3.seconds
        let datePreNotFoundPeriod = DateInRegion.init() - 5.minutes
        
        for (key, value) in dates {
            do {
                let date = try DateInRegion(string: key, format: .iso8601(options: .withInternetDateTime))
                
                // Any errors within few secs should give a break in trying again
                if(date.isAfter(date: datePreRetryPeriod, granularity: .second)) {
                    return true
                }
                
                // Not found errors within few min should give a break in trying again
                if(date.isAfter(date: datePreNotFoundPeriod, granularity: .second) && value.localizedDescription.equals(any: "notFound")) {
                    return true
                }
            } catch {
            }
        }
        
        return false
    }
}
