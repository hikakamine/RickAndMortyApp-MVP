import Foundation

struct CharacterData {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: LinkData
    let location: LinkData
    let image: String
    let episodes: [String]
    let url: String
    let created: String
}

// MARK: - Decodable protocol
extension CharacterData: Decodable {

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case species = "species"
        case type = "type"
        case gender = "gender"
        case origin = "origin"
        case location = "location"
        case image = "image"
        case episodes = "episode"
        case url = "url"
        case created = "created"
    }
}
