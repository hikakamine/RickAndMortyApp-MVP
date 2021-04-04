import Foundation

// MARK: - Cached Image or Download Task
enum ImageOrTask {
    case image(Data)
    case task(UUID)
    case error(String)
}

// MARK: - Equatable Protocol
extension ImageOrTask: Equatable {

    static func == (lhs: ImageOrTask,
                    rhs: ImageOrTask) -> Bool {
        switch (lhs, rhs) {
        case (.image(_), .image(_)):
            return true
        case (.task(_), .task(_)):
            return true
        case (.error(let msg1), .error(let msg2)):
            return msg1 == msg2
        default:
            return false
        }
    }
}

// MARK: - Download Task Image Response
enum ImageRequest {
    case image(Data)
    case cancelled
    case error(String)
}

// MARK: - ImageRequest Initialization
extension ImageRequest {

    init(_ error: NetworkRequestError) {
        switch error {
        case .cancelled:
            self = .cancelled
        default:
            self = .error(error.localizedDescription)
        }
    }

    init(_ data: Data) {
        self = .image(data)
    }
}

// MARK: - Equatable Protocol
extension ImageRequest: Equatable {

    static func == (lhs: ImageRequest,
                    rhs: ImageRequest) -> Bool {
        switch (lhs, rhs) {
        case (.image(_), .image(_)):
            return true
        case (.cancelled, .cancelled):
            return true
        case (.error(let msg1), .error(let msg2)):
            return msg1 == msg2
        default:
            return false
        }
    }
}
