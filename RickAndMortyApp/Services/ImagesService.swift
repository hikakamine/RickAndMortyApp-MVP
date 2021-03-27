import Foundation

enum ImageOrTask {
    case image(Data)
    case task(UUID)
    case error(String)
}

enum Image {
    case image(Data)
    case cancelled
    case error(String)
}

extension Image {
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

protocol ImagesLoader {

    func getImage(fromLocation location: String,
                  completionHandler: @escaping (Image) -> Void) -> ImageOrTask
    func cancelLoad(forUUID uuid: UUID)
}

class ImagesService: ImagesLoader {
    private var imageCache = [URL: Data]()
    private var requests = [UUID: URLSessionTask]()

    private let network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }

    func getImage(fromLocation location: String,
                  completionHandler: @escaping (Image) -> Void) -> ImageOrTask {
        guard let url = URL(string: location) else {
            return .error("URL[\(location)] not valid")
        }

        if let image = imageCache[url] {
            return .image(image)
        }

        let uuid = UUID()
        let task = network.donwloadData(fromURL: url) { result in
            defer { self.requests.removeValue(forKey: uuid) }

            switch result {
            case .failure(let error):
                completionHandler(Image(error))
            case .success(let data):
                self.imageCache[url] = data
                completionHandler(Image(data))
            }
        }

        requests[uuid] = task
        return .task(uuid)
    }

    func cancelLoad(forUUID uuid: UUID) {
        requests[uuid]?.cancel()
        requests.removeValue(forKey: uuid)
    }
}
