import Foundation

class RickAndMortyAPI: NetworkServiceProtocol {

    func downloadCharacters(fromURL url: URL,
                            completionHandler: @escaping (Result<ResultData<CharacterData>, ErrorMessage>) -> Void) {
        downloadData(fromURL: url) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                completionHandler(decode(data: data,
                                         asType: ResultData<CharacterData>.self))
            }
        }
    }
}

private func decode<T: Decodable>(data: Data,
                                  asType type: T.Type) -> Result<T, ErrorMessage> {
    do {
        return .success(try JSONDecoder().decode(type, from: data))
    } catch {
        return .failure(ErrorMessage(message: "Data parsing to type[\(type)] error"))
    }
}
