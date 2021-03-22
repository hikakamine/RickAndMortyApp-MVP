import Foundation

struct InfoData {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Decodable protocol
extension InfoData: Decodable {

    enum CodingKeys: String, CodingKey {
        case count = "count"
        case pages = "pages"
        case next = "next"
        case prev = "prev"
    }
}
