import Foundation

class URLProtocolStubs: URLProtocol {
    static var testURLs: [URL: (Data, HTTPURLResponse)]?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let clients = client,
              let testURLs = URLProtocolStubs.testURLs else {
            return
        }

        if let url = request.url,
           let (data, response) = testURLs[url] {
            clients.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            clients.urlProtocol(self, didLoad: data)
            clients.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() { }
}


