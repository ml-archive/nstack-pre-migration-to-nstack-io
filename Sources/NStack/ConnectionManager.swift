import HTTP
import Vapor

internal final class ConnectionManager {

    internal let client: Client
    internal let config: NStack.Config
    internal let cache: KeyedCache
    internal let logger: NStackLogger

    internal init(
        client: Client,
        config: NStack.Config,
        cache: KeyedCache,
        logger: NStackLogger
    ) throws {
        self.client = client
        self.config = config
        self.cache = cache
        self.logger = logger
    }
    
    internal func getTranslation(
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
                throw Abort(response.http.status)
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

    private func authHeaders(application: Application) -> HTTPHeaders {
        return [
            "Accept":"application/json",
            "X-Application-Id": application.applicationId,
            "X-Rest-Api-Key": application.restKey
        ];
    }
}
