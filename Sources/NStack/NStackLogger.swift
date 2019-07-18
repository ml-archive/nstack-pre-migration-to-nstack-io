import Vapor

final class NStackLogger {

    let enabled: Bool

    init(enabled: Bool) {
        self.enabled = enabled
    }

    func log(_ message: String) {
        if enabled {
            debugPrint("[NStack] \(message)")
        }
    }
}

extension NStackLogger: ServiceType {

    public static func makeService(for container: Container) -> Self {

        var enabled: Bool = false
        do {
            let config = try container.make(NStack.Config.self)
            enabled = config.log
        } catch {
            debugPrint("[NStack] No `NStack.Config` found. Log will be disabled.")
        }
        return self.init(enabled: enabled)
    }
}
