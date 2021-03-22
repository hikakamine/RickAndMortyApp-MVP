import Foundation

struct LinkData {
    let name: String
    let url: String?
}

// MARK: - Decodable protocol
extension LinkData: Decodable {

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}
