import Vapor

public struct File {
    public enum Privacy: String {
        case `public`
        case publicCdn = "public-cdn"
        case `private`
        case privatePassword = "private-password"
    }

    public let id: Int
    public let name: String
    public let tags: [String]?
    public let privacy: Privacy
    public let expiresAt: Date?
    public let mime: String
    public let size: Int
    public let password: String
    public let url: String
    public let cdnUrl: String?
    public let showUrl: String
    public let downloadUrl: String
}

internal extension File {
    init(_ json: JSON?) throws {
        guard
            let data = json?["data"]?.object,
            let id = data["id"]?.int,
            let name = data["name"]?.string,
            let privacyRaw = data["privacy"]?.string,
            let privacy = Privacy(rawValue: privacyRaw),
            let mime = data["mime"]?.string,
            let size = data["size"]?.int,
            let password = data["password"]?.string,
            let url = data["url"]?.string,
            let showUrl = data["show_url"]?.string,
            let downloadUrl = data["download_url"]?.string
        else {
            throw Abort(
                .internalServerError,
                metadata: nil,
                reason: "NStack error - Response was not OK"
            )
        }

        self.id = id
        self.name = name
        self.privacy = privacy
        self.mime = mime
        self.size = size
        self.password = password
        self.url = url
        self.showUrl = showUrl
        self.downloadUrl = downloadUrl

        self.tags = data["tags"]?.string?.split(separator: ",").map { String($0) }
        self.expiresAt = data["gone_at"]?.date
        self.cdnUrl = data["cdn_url"]?.string
    }
}
