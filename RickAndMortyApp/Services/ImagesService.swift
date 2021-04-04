import Foundation

protocol ImagesLoader {

    func getImage(fromLocation location: String,
                  completionHandler: @escaping (ImageRequest) -> Void) -> ImageOrTask
    func cancelLoad(forUUID uuid: UUID)
}

// MARK: - Images Service
class ImagesService {
    private let network: NetworkProtocol
    private let imageCache: Cache<URL, Data>
    private let requests: ThreadSafeDictionary<UUID, URLSessionTask>

    init(network: NetworkProtocol) {
        self.network = network
        imageCache = Cache()
        imageCache.name = "ImageCache"
        requests = ThreadSafeDictionary()
    }
}

// MARK: - ImagesLoader Protocol
extension ImagesService: ImagesLoader {

    func getImage(fromLocation location: String,
                  completionHandler: @escaping (ImageRequest) -> Void) -> ImageOrTask {
        guard let url = URL(string: location) else {
            return .error("URL[\(location)] not valid")
        }

        if let image = imageCache.getValue(forKey: url) {
            return .image(image)
        }

        let uuid = UUID()
        let task = network.donwloadData(fromURL: url) { [unowned self] result in
            defer { self.requests.removeValue(forKey: uuid) }

            switch result {
            case .failure(let error):
                completionHandler(ImageRequest(error))
            case .success(let data):
                self.imageCache.insert(data,
                                       forKey: url)
                completionHandler(ImageRequest(data))
            }
        }

        requests.insert(task,
                        forKey: uuid)
        return .task(uuid)
    }

    func cancelLoad(forUUID uuid: UUID) {
        requests.getValue(forKey: uuid)?.cancel()
        requests.removeValue(forKey: uuid)
    }
}
