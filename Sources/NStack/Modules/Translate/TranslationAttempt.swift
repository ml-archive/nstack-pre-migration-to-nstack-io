import Vapor
import Foundation

public class TranslationAttempt {

    public var dates: [Date: Error] = [:]

    init(error: Error) throws {
        try append(error: error)
    }

    public func append(error: Error) throws {
        dates[Date()] = error
    }

    public func avoidFetchingAgain() -> Bool {

        let datePreRetryPeriod = Date().addingTimeInterval(-3 * 60)
        let datePreNotFoundPeriod =  Date().addingTimeInterval(-5 * 60)

        for (date, error) in dates {

            // Any errors within few secs should give a break in trying again
            if date.compare(datePreRetryPeriod) == .orderedDescending {
                return true
            }

            // Not found errors within few min should give a break in trying again
            if date.compare(datePreNotFoundPeriod) == .orderedDescending
                && error.localizedDescription == "notFound" {

                return true
            }
        }
        return false
    }
}
