import Foundation

protocol ImagesLoader {

    func getImage(at location: String,
                  completionHandler: @escaping (Data) -> Void) -> UUID?
    func cancelLoad(forUUID uuid: UUID)
}

class ImagesService: ImagesLoader {
    private var imageCache = [URL: Data]()
    private var requests = [UUID: URLSessionTask]()

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
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            defer {
                self.requests.removeValue(forKey: uuid)
            }

            if let data = data {
                self.imageCache[url] = data
                completionHandler(data)
                return
            }

            if let error = error, (error as NSError).code != NSURLErrorCancelled {
                print(error)
                return
            }
        }
        task.resume()

        requests[uuid] = task
        return uuid
    }

    func cancelLoad(forUUID uuid: UUID) {
        requests[uuid]?.cancel()
        requests.removeValue(forKey: uuid)
    }
}
