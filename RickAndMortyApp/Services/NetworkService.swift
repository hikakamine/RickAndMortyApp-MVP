import Foundation

typealias DataRequest = (Result<Data, NetworkRequestError>) -> Void

protocol NetworkProtocol {

    func donwloadData(fromURL url: URL,
                      completionHandler: @escaping DataRequest) -> URLSessionTask
}

enum NetworkRequestError: Error {
    case api(_ status: Int,
             _ description: String)
    case cancelled
    case unknown(Data?, URLResponse?)
}

extension NetworkRequestError {
    init(_ data: Data?,
         _ response: URLResponse?,
         _ error: Error?) {
        guard let error = error else {
            self = NetworkRequestError.unknown(data, response)
            return
        }

        let code = (error as NSError).code
        switch code {
        case NSURLErrorCancelled:
            self = NetworkRequestError.api(code, error.localizedDescription)
        default:
            self = NetworkRequestError.cancelled
        }
    }
}

class NetworkService: NetworkProtocol {

    func donwloadData(fromURL url: URL,
                      completionHandler: @escaping DataRequest) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let responseData = data else {
                completionHandler(.failure(NetworkRequestError(data, response, error)))
                return
            }

            completionHandler(.success(responseData))
        }
        task.resume()
        return task
    }
}
