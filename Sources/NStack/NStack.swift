//import Cache
import Foundation
import Vapor
import HTTP

public final class NStack {

    public var application: Application

    internal let connectionManager: ConnectionManager
    internal let config: NStack.Config
    internal let applications: [Application]
    internal var defaultApplication: Application

    internal init(
        connectionManager: ConnectionManager,
        config: NStack.Config
    ) throws {

        self.connectionManager = connectionManager
        self.config = config
        self.applications = config.applicationConfigs.map { appConfig in
            Application(
                connectionManager: connectionManager,
                config: config,
                applicationConfig: appConfig
            )

        }
        guard let app = applications.first else {
            throw Abort(.internalServerError) // TODO: Add meaningful error
        }

        self.application = app
        self.defaultApplication = app
        self.defaultApplication = try getApplication(name: config.defaultApplicationName)
    }

    public func getApplication(name: String) throws -> Application {

        guard let app = applications.first(where: {$0.name == name}) else {
            throw Abort(.internalServerError) // TODO: Add meaningful error
        }
        return app
    }

    public func resetApplicationToDefault() {

        self.application = self.defaultApplication
    }
}

extension NStack: ServiceType {

    public static func makeService(for worker: Container) throws -> Self {

        let config = try worker.make(NStack.Config.self)
        let logger = try worker.make(NStackLogger.self)
        let cache = try worker.make(KeyedCache.self)

        let connectionManager = try ConnectionManager(
            client: FoundationClient.default(on: worker),
            config: config,
            cache: cache,
            logger: logger
        )
        return try self.init(
            connectionManager: connectionManager,
            config: config
        )
    }
}
