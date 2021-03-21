import UIKit

class RickAndMortyAPI: NetworkServiceProtocol {

    func downloadResult<T: Decodable>(fromURL url: URL,
                                      completionHandler: @escaping (Result<T, ErrorMessage>) -> Void) {
        downloadData(forURL: url) { result in
            switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                case .success(let data):
                    completionHandler(decode(data: data, asType: T.self))
            }
        }
    }

    func downloadImage(fromURL url: URL,
                       completionHandler: @escaping (Result<UIImage, ErrorMessage>) -> Void) {
        downloadData(forURL: url) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                completionHandler(decode(data: data))
            }
        }
    }
}

private func decode<T: Decodable>(data: Data, asType type: T.Type) -> Result<T, ErrorMessage> {
    do {
        return .success(try JSONDecoder().decode(type, from: data))
    } catch {
        return .failure(ErrorMessage(message: "Data parsing to type[\(type)] error"))
    }
}

private func decode(data: Data) -> Result<UIImage, ErrorMessage> {
    guard let image = UIImage(data: data) else {
        return .failure(ErrorMessage(message: "Image data is corrupted"))
    }

    return .success(image)
}
