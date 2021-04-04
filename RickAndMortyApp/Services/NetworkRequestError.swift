import Foundation

enum NetworkRequestError: Error {
    case cancelled
    case other(Int, String)
    case nullData(URLResponse?)
    case redirect(Data)
    case client(Data)
    case server(Data)
    case unknown(Data?, URLResponse?)
}

// MARK: - Initialization from URLSessionDataTask completion handler response
extension NetworkRequestError {

    init?(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        if let error = error {
            let code = (error as NSError).code
            switch code {
            case NSURLErrorCancelled:
                self = .cancelled
            default:
                self = .other(code, error.localizedDescription)
            }
            return
        }

        guard let validData = data else {
            self = .nullData(response)
            return
        }

        let statusCode = (response as! HTTPURLResponse).statusCode
        guard (200...299).contains(statusCode) else {
            switch statusCode {
            case (300...399):
                self = .redirect(validData)
            case (400...499):
                self = .client(validData)
            case (500...599):
                self = .server(validData)
            default:
                self = .unknown(data, response)
            }
            return
        }

        return nil
    }
}
