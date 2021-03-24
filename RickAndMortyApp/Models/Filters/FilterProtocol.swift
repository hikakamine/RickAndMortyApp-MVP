import Foundation

protocol FilterProtocol {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension FilterProtocol {
    var scheme: String { get { "https" } }
    var host: String { get { "rickandmortyapi.com" } }
    var apiPath: String { get { "/api" } }
    var url: URL? {
        get {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = apiPath + path
            if !queryItems.isEmpty {
                components.queryItems = queryItems
            }
            return components.url
        }
    }
}
