import Cache
import FormData
import Multipart
import Foundation
import HTTP
import TLS
import Vapor

public final class ConnectionManager {
    private static let baseUrl = "https://nstack.io/api/v1/"
    internal let cache: CacheProtocol
    internal let client: ClientProtocol
    private let translateConfig: TranslateConfig

    public init(
        cache: CacheProtocol,
        clientFactory: ClientFactoryProtocol,
        nStackConfig: NStackConfig
    ) throws {
        self.cache = cache
        client = try clientFactory.makeClient(
            hostname: ConnectionManager.baseUrl,
            port: 443,
            securityLayer: .tls(Context(.client))
        )
        translateConfig = nStackConfig.translate
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

    func storeFile(
        application: Application,
        data: Data,
        name: String,
        privacy: String,
        tags: String?,
        expiresAt: Date?
    ) throws -> File {
        var headers = self.authHeaders(application: application)
        headers[.contentType] = "application/x-www-form-urlencoded"
        let url = ConnectionManager.baseUrl + "content/files"

        let nameField = FormData.Field(
            name: "name", filename: nil, part: Part(headers: [:], body: name.makeBytes())
        )
        let privacyField = FormData.Field(
            name: "privacy", filename: nil, part: Part(headers: [:], body: privacy.makeBytes())
        )
        let fileField = FormData.Field(
            name: "file", filename: "export.csv", part: Part(headers: [:], body: data.makeBytes())
        )

        var formData: [String: FormData.Field] = [
            "name": nameField,
            "privacy": privacyField,
            "file": fileField
        ]

        if let tags = tags {
            let tagsField = FormData.Field(
                name: "tags", filename: nil, part: Part(headers: [:], body: tags.makeBytes())
            )
            formData["tags"] = tagsField
        }

        if let expiresAt = expiresAt, let dateString = try? expiresAt.toDateTimeString(timezone: "UTC").makeBytes() {
            let expiresAtField = FormData.Field(
                name: "gone_at",
                filename: nil,
                part: Part(headers: [:], body: dateString)
            )
            formData["gone_at"] = expiresAtField
        }

        let request = Request(method: .post, uri: url, headers: headers, body: Body())
        request.formData = formData

        let storeFileResponse = try client.respond(to: request)

        guard
            storeFileResponse.status == .ok
        else {
            throw Abort(
                .internalServerError,
                metadata: nil,
                reason: "NStack error - Response was not OK"
            )
        }

        return try File(storeFileResponse.json)
    }
    
    func authHeaders(application: Application) -> [HeaderKey : String] {
        return [
            "Accept":"application/json",
            "X-Application-Id": application.applicationId,
            "X-Rest-Api-Key": application.restKey
        ];
    }
}
