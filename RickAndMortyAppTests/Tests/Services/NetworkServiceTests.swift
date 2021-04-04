import XCTest
@testable import RickAndMortyApp

// MARK: - Test setup
class NetworkServiceTests: XCTestCase {

    var subject: NetworkProtocol!
    var testExpectation: XCTestExpectation!

    override func setUp() {
        super.setUp()

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStubs.self]
        subject = NetworkService(session: URLSession(configuration: configuration))
        testExpectation = expectation(description: "Expectation")
    }

    override func tearDown() {
        super.tearDown()

        URLProtocolStubs.testURLs = nil
    }
}

// MARK: - Tests
extension NetworkServiceTests {

    func test_GivenAValidURL_WhenDownloadData_ThenResultIsSuccess() {
        URLProtocolStubs.testURLs = TestURLs.CharactersData.test

        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        var result = false

        _ = subject.donwloadData(fromURL: url) { response in
            if case .success = response {
                result = true
            }
            self.testExpectation.fulfill()
        }

        wait(for: [testExpectation], timeout: 1.0)
        XCTAssertTrue(result, "Result not a success")
    }

    func test_GivenAnyURL_WhenDownloadDataIsCancelled_ThenResultIsNetworkCancelled() {
        URLProtocolStubs.testURLs = TestURLs.CharactersData.test

        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        var result = false

        let task = subject.donwloadData(fromURL: url) { response in
            if case .failure(let error) = response,
               case .cancelled = error {
                result = true
            }
            self.testExpectation.fulfill()
        }
        task.cancel()

        wait(for: [testExpectation], timeout: 1.0)
        XCTAssertTrue(result, "Request not cancelled")
    }

    func test_GivenIncorrectURL_WhenDownloadData_ThenReturnHTTPCLientError() {
        URLProtocolStubs.testURLs = TestURLs.InvalidURL.test

        let url = URL(string: "https://rickandmortyapi.com/api/characters")!
        var result = false

        _ = subject.donwloadData(fromURL: url) { response in
            if case .failure(let error) = response,
               case .client = error {
                result = true
            }
            self.testExpectation.fulfill()
        }

        wait(for: [testExpectation], timeout: 1.0)
        XCTAssertTrue(result, "URL is valid")
    }
}
