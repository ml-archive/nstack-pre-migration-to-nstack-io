import Foundation
import Vapor
import HTTP

public typealias Translate = TranslateController

public final class NStack {

    public var application: Application

    internal let connectionManager: ConnectionManager
    internal let config: NStack.Config
    internal let applications: [Application]
    internal var defaultApplication: Application
    
    internal init(
        connectionManager: ConnectionManager,
        config: NStack.Config,
        translateConfig: Translate.Config? = nil
    ) throws {

        self.connectionManager = connectionManager
        self.config = config
        self.applications = config.applicationConfigs.map { appConfig in
            Application(
                connectionManager: connectionManager,
                config: config,
                applicationConfig: appConfig,
                translateConfig: translateConfig
            )
        }
        guard let app = applications.first else {
            throw Abort(
                .internalServerError,
                reason: "[NStack] No application found. You have to provide at least 1 application."
            )
        }

        self.application = app
        self.defaultApplication = app
        self.defaultApplication = try getApplication(name: config.defaultApplicationName)
    }
    
    internal convenience init(on container: Container, cache: KeyedCache? = nil) throws {
        
        let config = try container.make(NStack.Config.self)
        let client = try container.make(Client.self)
        
        let connectionManager = try ConnectionManager(
            client: client,
            config: config,
            cache: cache ?? container.make(KeyedCache.self)
        )
        
        try self.init(
            connectionManager: connectionManager,
            config: config,
            translateConfig: config.defaultTranslateConfig
        )
    }

    public func getApplication(name: String) throws -> Application {

        guard let app = applications.first(where: {$0.name == name}) else {
            throw Abort(
                .internalServerError,
                reason: "[NStack] No defaultApplication with the name '\(name)' found."
            )
        }
        return app
    }

    public func resetApplicationToDefault() {

        self.application = self.defaultApplication
    }
}

extension NStack: ServiceType {

    public static func makeService(for worker: Container) throws -> Self {
        
        return try self.init(on: worker)
    }
}
