import Vapor
import HTTP

public final class ConnectionManager {
    let drop: Droplet
    let baseUrl = "https://nstack.io/api/v1/"

    public init(drop: Droplet) {
        self.drop = drop
    }
    
    func getTranslation(application: Application, platform: String, language: String) throws -> Translation {
        
        var headers = self.authHeaders(application: application)
        headers["Accept-Language"] = language
        
        let url = baseUrl + "translate/" + platform + "/keys"
        let translateResponse = try drop.client.get(url, query: [:], headers)

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
        
        return Translation(drop: self.drop, application: application, json: json, platform: platform, language: language)
    }
    
    func authHeaders(application: Application) -> [HeaderKey : String] {
        return [
            "Accept":"application/json",
            "X-Application-Id": application.applicationId,
            "X-Rest-Api-Key": application.restKey
        ];
    }
}
