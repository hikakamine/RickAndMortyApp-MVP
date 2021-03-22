import Foundation

struct EpisodeData {
    let id: Int
    let name: String
    let airDate: String
    let episodeCode: String
    let characters: [String]
}

// MARK: - Decodable protocol
extension EpisodeData: Decodable {

    enum CondingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case airDate = "air_date"
        case episodeCode = "episode"
        case characters = "characters"
    }
}
