import Foundation

typealias CharacterResult = (Result<ResultData<CharacterData>, ApiRequestError>) -> Void

enum ApiRequestError: Error {
    case invalidUrl
    case cancelled
    case decodeError(String)
    case unknown(String)
}

extension ApiRequestError {
    init(_ networkError: NetworkRequestError) {
        switch networkError {
        case .cancelled:
            self = .cancelled
        default:
            self = .unknown("\(networkError)")
        }
    }
}

protocol ApiProtocol {

//    func downloadCharacters(from urlString: String,
//                            completionHandler: @escaping CharacterResult) -> URLSessionTask?
    func downloadCharacters(fromURL url: URL,
                            completionHandler: @escaping CharacterResult) -> URLSessionTask?
}

class RickAndMortyApi {
    private let network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }
}

extension RickAndMortyApi: ApiProtocol {

//    func downloadCharacters(from urlString: String,
//                            completionHandler: @escaping CharacterResult) -> URLSessionTask? {
//        guard let url = URL(string: urlString) else {
//            completionHandler(.failure(ApiRequestError.invalidUrl))
//            return nil
//        }
//
//        let task = downloadCharacters(fromURL: url) { result in
//            completionHandler(result)
//            return
//        }
//        return task
//    }

    func downloadCharacters(fromURL url: URL,
                            completionHandler: @escaping CharacterResult) -> URLSessionTask? {
        let task = network.donwloadData(fromURL: url) { [unowned self] result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(ApiRequestError(error)))
            case .success(let data):
                completionHandler(self.decode(data: data,
                                              asType: ResultData<CharacterData>.self))
            }
        }
        return task
    }

    func decode<T: Decodable>(data: Data,
                              asType type: T.Type) -> Result<T, ApiRequestError> {
        do {
            return .success(try JSONDecoder().decode(type, from: data))
        } catch {
            return .failure(ApiRequestError.decodeError("Data parsing to type[\(type)] error"))
        }
    }
}
