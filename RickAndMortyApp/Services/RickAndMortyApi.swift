import Foundation

typealias CharacterResult = Result<ResultData<CharacterData>, ApiRequestError>

protocol ApiProtocol {

    func downloadCharacters(fromURL url: URL,
                            completionHandler: @escaping (CharacterResult) -> Void) -> URLSessionTask?
}

class RickAndMortyApi {
    private let network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }
}

extension RickAndMortyApi: ApiProtocol {

    func downloadCharacters(fromURL url: URL,
                            completionHandler: @escaping (CharacterResult) -> Void) -> URLSessionTask? {
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
            return .failure(.parsing("Data parsing to type [\(type)] error"))
        }
    }
}
