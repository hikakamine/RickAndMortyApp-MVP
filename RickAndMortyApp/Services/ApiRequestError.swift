import Foundation

enum ApiRequestError: Error {
    case cancelled
    case parsing(String)
    case invalidUrl
    case other(String)
}

// MARK: - Initialization from NetworkRequestError
extension ApiRequestError {

    init(_ networkError: NetworkRequestError) {
        switch networkError {
        case .cancelled:
            self = .cancelled
        case .client(_):
            self = .invalidUrl
        default:
            self = .other("\(networkError)")
        }
    }
}

// MARK: - Equatable Protocol
extension ApiRequestError: Equatable {

    static func == (lhs: ApiRequestError,
                    rhs: ApiRequestError) -> Bool {
        switch (lhs, rhs) {
        case (.cancelled, .cancelled):
            return true
        case (let .parsing(a1), let .parsing(a2)):
            return a1 == a2
        case (.invalidUrl, .invalidUrl):
            return true
        case (.other(_), .other(_)):
            return true
        default:
            return false
        }
    }
}
