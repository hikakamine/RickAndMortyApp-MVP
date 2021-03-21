import Foundation

struct ResultData<T: Decodable> {
    let info: InfoData
    let results: [T]
}

// MARK: - Decodable protocol
extension ResultData: Decodable {

    enum CodingKeys: String, CodingKey {
        case info = "info"
        case results = "results"
    }
}
