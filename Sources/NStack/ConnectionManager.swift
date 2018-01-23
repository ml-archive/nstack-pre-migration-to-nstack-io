import Cache
import HTTP
import Vapor

public final class ConnectionManager {
    static let baseUrl = "https://nstack.io/api/v1/"
    internal var client: ClientProtocol?
    internal var cache: CacheProtocol?
    private let translateConfig: TranslateConfig

    init(translateConfig: TranslateConfig) throws {
        self.translateConfig = translateConfig
    }
    
    func getTranslation(application: Application, platform: String, language: String) throws -> Translation {
        
        var headers = self.authHeaders(application: application)
        headers["Accept-Language"] = language
        
        let url = ConnectionManager.baseUrl + "translate/" + platform + "/keys"

        guard let client = client else {
            throw Abort(.internalServerError, reason: "Client is not set up")
        }

        let translateResponse = try client.get(url, query: [:], headers)

        if(translateResponse.status != .ok) {
            
            if(translateResponse.status.statusCode == 445) {
                throw Abort.notFound
            }
            
            throw Abort(
                .internalServerError,
                metadata: nil,
                reason: "NStack error - Response was not OK"
            )
        }
        
        guard let json: JSON = translateResponse.json else {
            throw Abort(
                .internalServerError,
                metadata: nil,
                reason: "NStack error - Could not unwrap json"
            )
        }
        
        return Translation(translateConfig: translateConfig, application: application, json: json, platform: platform, language: language)
    }
    
    func authHeaders(application: Application) -> [HeaderKey : String] {
        return [
            "Accept":"application/json",
            "X-Application-Id": application.applicationId,
            "X-Rest-Api-Key": application.restKey
        ];
    }
}
