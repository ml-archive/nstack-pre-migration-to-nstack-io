import Vapor
import Foundation

extension Localization {

    public struct ResponseData: Codable {

        public let translations: LocalizationFormat
        public let meta: Meta

        public struct Meta: Codable {

            public let language: Language
            public let acceptLanguage: String

            public struct Language: Codable {

                let id: Int
                let name: String
                let locale: String
                let direction: String
                let isDefault: Bool

                enum CodingKeys: String, CodingKey {
                    case id
                    case name
                    case locale
                    case direction
                    case isDefault = "is_default"
                }
            }

            enum CodingKeys: String, CodingKey {
                case language
                case acceptLanguage = "Accept-Language"
            }
        }

        enum CodingKeys: String, CodingKey {
            case translations = "data"
            case meta
        }
    }
}
