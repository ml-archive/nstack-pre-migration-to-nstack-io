import Vapor

struct UpdateResponse: Content {
    let update: String
    let updateVersions: [UpdateVersion]
    let newInVersion: Bool
    let newInVersions: [String]

    enum CodingKeys: String, CodingKey {
        case update
        case updateVersions = "update_versions"
        case newInVersion = "new_in_version"
        case newInVersions = "new_in_versions"
    }
}

public struct UpdateVersion: Content {
    public let id: Int
    public let version: String
    public let update: String
    public let newInVersion: Bool
    public let changeLog: String?
    public let fileUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case version
        case update
        case newInVersion = "new_in_version"
        case changeLog = "change_log"
        case fileUrl = "file_url"
    }
}
