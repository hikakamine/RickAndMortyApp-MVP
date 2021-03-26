import Foundation

protocol ImagesLoader {

    func getImage(at location: String,
                  completionHandler: @escaping (Data) -> Void) -> UUID?
    func cancelLoad(forUUID uuid: UUID)
}

class ImagesService: ImagesLoader {
    private var imageCache = [URL: Data]()
    private var requests = [UUID: URLSessionTask]()

    private let network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }

    func getImage(at location: String,
                  completionHandler: @escaping (Data) -> Void) -> UUID? {
        guard let url = URL(string: location) else {
            return nil
        }

        if let image = imageCache[url] {
            completionHandler(image)
            return nil
        }

        let uuid = UUID()
        let task = network.donwloadData(fromURL: url) { result in
            defer { self.requests.removeValue(forKey: uuid) }

            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                self.imageCache[url] = data
                completionHandler(data)
            }
        }

        requests[uuid] = task
        return uuid
    }

    func cancelLoad(forUUID uuid: UUID) {
        requests[uuid]?.cancel()
        requests.removeValue(forKey: uuid)
    }
}
