import Foundation

typealias DataRequest = Result<Data, NetworkRequestError>

protocol NetworkProtocol {

    func donwloadData(fromURL url: URL,
                      completionHandler: @escaping (DataRequest) -> Void) -> URLSessionTask
}

class NetworkService: NetworkProtocol {
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func donwloadData(fromURL url: URL,
                      completionHandler: @escaping (DataRequest) -> Void) -> URLSessionTask {
        let task = session.dataTask(with: url) { (data, response, error) in
            if let networkError = NetworkRequestError(data, response, error) {
                completionHandler(.failure(networkError))
                return
            }

            completionHandler(.success(data!))
        }
        task.resume()
        return task
    }
}
