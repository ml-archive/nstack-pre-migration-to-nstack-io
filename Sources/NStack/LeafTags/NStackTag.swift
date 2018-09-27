import Vapor
import Leaf

/// NStackTag - Leaf tag for translation in leaf views
/// Usage: #nstack("section", "key")
public final class NStackTag: BasicTag {
    public let name: String = "nstack"
    let translation: Translate?
    
    /// init
    ///
    /// - Parameter nStack: NStack
    public init(nStack: NStack?) {
        self.translation = nStack?.application.translate
    }
    
    /// run
    ///
    /// - Parameter arguments: ArgumentList
    /// - Returns: Node
    /// - Throws: AbortError
    public func run(arguments: ArgumentList) throws -> Node? {
        guard let section = arguments[0]?.string else {
            throw Abort(.internalServerError, reason: "Missing section")
        }
        
        guard let key = arguments[1]?.string else {
            throw Abort(.internalServerError, reason: "Missing key")
        }
        
        let translated = self.translation?.get(
            section: section,
            key: key
        )
        
        return .string(translated ?? key)
    }
}
