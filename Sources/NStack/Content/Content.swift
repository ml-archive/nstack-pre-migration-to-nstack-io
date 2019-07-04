import Vapor
import Foundation
import Cache

public final class Content {
    let application: Application

    var cache: CacheProtocol? {
        return application.cache
    }

    public init(application: Application) {
        self.application = application
    }

    public func store(
        _ data: Data,
        name: String,
        privacy: File.Privacy,
        tags: [String]? = nil,
        expiresAt: Date? = nil
    ) throws -> File {
        return try application.connectionManager.storeFile(
            application: application,
            data: data,
            name: name,
            privacy: privacy.rawValue,
            tags: tags?.joined(separator: ","),
            expiresAt: expiresAt
        )
    }
}
