import Foundation

struct CharactersFilter {
    var name: String = ""
    var status: String = ""
    var gender: String = ""
}

// MARK: - FilterProtocol
extension CharactersFilter: FilterProtocol {

    fileprivate var trimmedName: String {
        get { name.trimmingCharacters(in: [" "]) }
    }

    var path: String { get { "/character" } }

    var queryItems: [URLQueryItem] {
        get {
            var queryItems = [URLQueryItem]()

            if !name.isEmpty {
                queryItems.append(URLQueryItem(name: "name", value: trimmedName))
            }

            if !status.isEmpty {
                queryItems.append(URLQueryItem(name: "status", value: status))
            }

            if !gender.isEmpty {
                queryItems.append(URLQueryItem(name: "gender", value: gender))
            }

            return queryItems
        }
    }
}

// MARK: - Equatable protocol
extension CharactersFilter: Equatable {

    static func == (lhs: CharactersFilter,
                    rhs: CharactersFilter) -> Bool {
        return lhs.trimmedName.lowercased() == rhs.trimmedName.lowercased()
            && lhs.status.lowercased() == rhs.status.lowercased()
            && lhs.gender.lowercased() == rhs.gender.lowercased()
    }
}
