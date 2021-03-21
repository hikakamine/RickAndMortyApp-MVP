import Foundation

struct InfoData {
    let count: Int
    let pages: Int
    let next: URL?
    let prev: URL?
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
