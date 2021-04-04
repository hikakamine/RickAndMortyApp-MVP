import XCTest
@testable import RickAndMortyApp

// MARK: - Test setup
class RickAndMortyApiTests: XCTestCase {

    var subject: RickAndMortyApi!
    var networkMock: NetworkProtocol!
    var testExpectation: XCTestExpectation!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolStubs.self]
        networkMock = NetworkService(session: URLSession.init(configuration: config))
        subject = RickAndMortyApi(network: networkMock)
        testExpectation = expectation(description: "Expectation")
    }

    override func tearDown() {
        super.tearDown()

        URLProtocolStubs.testURLs = nil
    }
}

// MARK: - Tests
extension RickAndMortyApiTests {

    func test_GivenValidData_WhenDownloadCharacters_ThenParsesData() {
        URLProtocolStubs.testURLs = TestURLs.CharactersData.test

        var result: ResultData<CharacterData>!
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        _ = subject.downloadCharacters(fromURL: url) { response in
            if case .success(let data) = response {
                result = data
            }
            self.testExpectation.fulfill()
        }

        wait(for: [testExpectation], timeout: 1.0)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.results.count, 20)
    }

    func test_GivenInvalidUrl_WhenDonwloadCharacters_ThenReturnInvalidUrlError() {
        URLProtocolStubs.testURLs = TestURLs.InvalidURL.test

        var result: ApiRequestError!
        let expect = ApiRequestError.invalidUrl
        let url = URL(string: "https://rickandmortyapi.com/api/characters")!
        _ = subject.downloadCharacters(fromURL: url) { response in
            if case .failure(let error) = response {
                result = error
            }
            self.testExpectation.fulfill()
        }

        wait(for: [testExpectation], timeout: 1.0)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, expect)
    }

    func test_GivenSingleCharacter_WhenDownloadCharacters_ThenReturnParsingError() {
        URLProtocolStubs.testURLs = TestURLs.SingleCharacterData.test

        var result: ApiRequestError!
        let expect = ApiRequestError.parsing("Data parsing to type [ResultData<CharacterData>] error")
        let url = URL(string: "https://rickandmortyapi.com/api/character/1")!
        _ = subject.downloadCharacters(fromURL: url) { response in
            if case .failure(let error) = response {
                result = error
            }
            self.testExpectation.fulfill()
        }

        wait(for: [testExpectation], timeout: 1.0)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, expect)
    }
}
