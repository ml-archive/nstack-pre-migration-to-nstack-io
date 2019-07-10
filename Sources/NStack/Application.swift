import Vapor

public struct Application {

    internal var connectionManager: ConnectionManager
    internal let config: NStack.Config
    internal let applicationConfig: Application.Config
    internal let translateConfig: Translate.Config?

    internal var name: String { get { return applicationConfig.name }}
    internal var applicationId: String { get { return applicationConfig.applicationId }}
    internal var restKey: String { get { return applicationConfig.restKey }}
    internal var masterKey: String { get { return applicationConfig.masterKey }}

    internal var cache: KeyedCache { get { return connectionManager.cache }}
    
    public lazy var translate: TranslateController = TranslateController(
        application: self,
        config: self.translateConfig ?? Translate.Config.default
    )

    public private(set) lazy var version = VersionController(application: self)

    internal init(
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
