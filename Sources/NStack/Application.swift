import Vapor

public struct Application {

    var connectionManager: ConnectionManager
    let config: NStack.Config
    let applicationConfig: Application.Config
    let translateConfig: Translate.Config?

    var name: String { return applicationConfig.name }
    var applicationId: String { return applicationConfig.applicationId }
    var restKey: String { return applicationConfig.restKey }

    var cache: KeyedCache { return connectionManager.cache }
    
    public lazy var translate: TranslateController = TranslateController(
        application: self,
        config: self.translateConfig ?? Translate.Config.default
    )

    public private(set) lazy var version = VersionController(application: self)

    init(
        connectionManager: ConnectionManager,
        config: NStack.Config,
        applicationConfig: Application.Config,
        translateConfig: Translate.Config? = nil
    ) {
        self.connectionManager = connectionManager
        self.config = config
        self.applicationConfig = applicationConfig
        self.translateConfig = translateConfig ?? Translate.Config.default
    }
}
