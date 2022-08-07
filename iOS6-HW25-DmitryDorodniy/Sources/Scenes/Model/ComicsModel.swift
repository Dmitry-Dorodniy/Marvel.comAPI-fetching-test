import Foundation

struct DataMarvel: Decodable {
    let data: Results

    struct Results: Decodable {
        let total: Int
        let results: [Comic]
    }
}

struct Comic: Decodable {
    let title: String
    let issueNumber: Double?
    let description: String?
    let thumbnail: ImagePath?
    let characters: Heroes?

    struct ImagePath: Decodable {
        let path: String
        let imageExtension: String

        enum CodingKeys: String, CodingKey {
            case path
            case imageExtension = "extension"
        }
    }

    struct Heroes: Decodable {
        let items: [Name]

        struct Name: Decodable {
        let name: String
        }
    }
}
