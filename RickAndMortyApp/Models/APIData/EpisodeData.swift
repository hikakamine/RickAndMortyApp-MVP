import Foundation

struct EpisodeData {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [URL]
}

// MARK: - Decodable protocol
extension EpisodeData: Decodable {

    enum CondingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case airDate = "air_date"
        case episode = "episode"
        case characters = "characters"
    }
}
