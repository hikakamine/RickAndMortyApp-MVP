import Foundation

struct LocationData {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
}

// MARK: - Decodable protocol
extension LocationData: Decodable {

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case type = "type"
        case dimension = "dimension"
        case residents = "residents"
    }
}
