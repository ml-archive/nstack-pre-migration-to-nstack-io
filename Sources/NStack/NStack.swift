//import Cache
import Foundation
import Vapor
import HTTP

public final class NStack: Service {

//    public let connectionManager: ConnectionManager
//    public let config: NStackConfig
//    var defaultApplication: Application
//
//    public let applications: [Application]
//    public var application: Application

    public init(config: NStackConfig, connectionManager: ConnectionManager) throws {
        
    }

//    public init(config: NStackConfig, connectionManager: ConnectionManager) throws {
//        self.config = config
//        self.connectionManager = connectionManager
//
//        // Set applications
//        var applications: [Application] = []
//        for applicationConfig in self.config.applications {
//            applications.append(Application(connectionManager: connectionManager, applicationConfig: applicationConfig, nStackConfig: config))
//        }
//
//        self.applications = applications
//
//        // Set first application
//        guard let app: Application = applications.first else {
//            throw Abort.serverError
//        }
//
//        self.application = app
//        self.defaultApplication = app
//
//        // Set picked application
//        self.defaultApplication = try setApplication(name: config.defaultApplication)
//    }
//
//    public func setApplication(name: String) throws -> Application {
//        for application in applications {
//            if(application.name == name) {
//                self.application = application
//
//                return self.application
//            }
//        }
//
//        throw Abort(
//            .internalServerError,
//            metadata: nil,
//            reason: "NStack - Application \(name) was not found"
//        )
//    }
//
//    public func setApplicationToDefault() -> Application {
//        self.application = self.defaultApplication
//
//        return application
//    }
}

extension NStack: ServiceType {

    public static func makeService(for worker: Container) throws -> Self {
        return .init()
    }
}
