import HTTP
import Vapor

final class ConnectionManager {

    let client: Client
    let config: NStack.Config
    let cache: KeyedCache

    init(
        client: Client,
        config: NStack.Config,
        cache: KeyedCache
    ) throws {
        self.client = client
        self.config = config
        self.cache = cache
    }
    
    func getTranslation(
        application: Application,
        platform: Translate.Platform,
        language: String
    ) throws -> Future<Localization> {

        var headers = self.authHeaders(application: application)
        headers.add(name: "Accept-Language", value: language)

        let url = config.baseURL + "translate/" + platform.rawValue + "/keys"

        let translateResponse = client.get(url, headers: headers)

        return translateResponse.flatMap { response in

            guard response.http.status == .ok else {
                throw Abort(
                    response.http.status,
                    reason: "[NStack] Error fetching translations: \(response)"
                )
            }

            return try response.content.decode(Localization.ResponseData.self)
                .map { responseData in
                    return Localization(
                        responseData: responseData,
                        platform: platform,
                        language: language
                    )
                }
        }
    }

    func getUpdate(
        application: Application,
        for platform: VersionController.Platforms,
        currentVersion: String = "0.0",
        lastVersion: String? = nil
    ) -> Future<UpdateResponse> {
        let headers = self.authHeaders(application: application)
        let url = config.baseURL + "notify/updates"
        let updateResponse = client.get(url, headers: headers) { get in
            try get.query.encode([
                "platform": platform.rawValue,
                "current_version": "0.0",
                "last_version": lastVersion
            ])
        }

        return updateResponse.flatMap { response in
            guard response.http.status == .ok else {
                throw Abort(
                    response.http.status,
                    reason: "[NStack] Error fetching version updates: \(response)"
                )
            }

            return try response.content.decode(UpdateResponse.self)
        }
    }

    private func authHeaders(application: Application) -> HTTPHeaders {
        return [
            "Accept":"application/json",
            "X-Application-Id": application.applicationId,
            "X-Rest-Api-Key": application.restKey
        ]
    }
}
