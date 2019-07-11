import Vapor

public final class VersionController {

    private let application: Application

    init(application: Application) {
        self.application = application
    }

    public func getLatestVersion(for platform: Platforms) -> Future<UpdateVersion?> {
        let updateResponse = application.connectionManager.getUpdate(
            application: application,
            for: platform
        )

        return updateResponse.map { response in
            response.updateVersions.sorted(by: { $0.id > $1.id } ).first
        }
    }
}

extension VersionController {
    public enum Platforms: String {
        case ios
        case android
    }
}
