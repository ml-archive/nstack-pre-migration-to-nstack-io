extension Localization {

    internal struct ResponseData: Codable {

        internal let translations: LocalizationFormat
        internal let meta: Meta

        internal struct Meta: Codable {

            internal let language: Language
            internal let acceptLanguage: String

            internal struct Language: Codable {

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
