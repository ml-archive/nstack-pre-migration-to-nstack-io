import Vapor
import HTTP
import TLS

public final class ConnectionManager {
    static let baseUrl = "https://nstack.io/api/v1/"
    private let client: ClientProtocol
    private let translateConfig: TranslateConfig

    init(translateConfig: TranslateConfig, clientFactory: ClientFactoryProtocol) throws {
        self.client = try clientFactory.makeClient(
            hostname: ConnectionManager.baseUrl,
            port: 443,
            securityLayer: .tls(Context(.client))
        )
        self.translateConfig = translateConfig
    }
    
    func getTranslation(application: Application, platform: String, language: String) throws -> Translation {
        
        var headers = self.authHeaders(application: application)
        headers["Accept-Language"] = language
        
        let url = ConnectionManager.baseUrl + "translate/" + platform + "/keys"
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
