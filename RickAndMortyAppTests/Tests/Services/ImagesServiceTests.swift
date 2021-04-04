import XCTest
@testable import RickAndMortyApp

// MARK: - Test setup
class ImagesServiceTests: XCTestCase {

    var subject: ImagesService!
    var networkMock: NetworkProtocol!
    var testExpectation: XCTestExpectation!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolStubs.self]
        networkMock = NetworkService(session: URLSession.init(configuration: config))
        subject = ImagesService(network: networkMock)
    }

    override func tearDown() {
        super.tearDown()

        URLProtocolStubs.testURLs = nil
    }
}

// MARK: - Tests
extension ImagesServiceTests {

    func test_GivenImageUrl_WhenGetImage_ThenReturnTaskAndAValidImage() {
        URLProtocolStubs.testURLs = TestURLs.ImageData.test
        testExpectation = expectation(description: "Expectation")

        var resultData: ImageRequest!
        let expect = ImageRequest.image(Data())
        let urlString = "https://rickandmortyapi.com/api/character/avatar/00.jpeg"
        let resultTask = subject.getImage(fromLocation: urlString) { response in
            resultData = response
            self.testExpectation.fulfill()
        }
        XCTAssertEqual(resultTask, .task(UUID()))

        wait(for: [testExpectation], timeout: 1.0)
        XCTAssertNotNil(resultData)
        XCTAssertEqual(resultData, expect)
    }

    func test_GivenCachedImage_WhenGetImage_ThenReturnCachedValidImage() {
        URLProtocolStubs.testURLs = TestURLs.ImageData.test
        testExpectation = expectation(description: "Expectation")

        let urlString = "https://rickandmortyapi.com/api/character/avatar/00.jpeg"
        _ = subject.getImage(fromLocation: urlString) { _ in
            self.testExpectation.fulfill()
        }
        wait(for: [testExpectation], timeout: 1.0)

        let result = subject.getImage(fromLocation: urlString) { _ in }
        XCTAssertNotNil(result)
        XCTAssertEqual(result, .image(Data()))
    }

    func test_GivenImageUrl_WhenCancelGetImageTask_ThenReturnCancelled() {
        URLProtocolStubs.testURLs = TestURLs.ImageData.test
        testExpectation = expectation(description: "Expectation")

        var result: ImageRequest!
        let expect = ImageRequest.cancelled
        let urlString = "https://rickandmortyapi.com/api/character/avatar/00.jpeg"
        let task = subject.getImage(fromLocation: urlString) { response in
            result = response
            self.testExpectation.fulfill()
        }
        if case .task(let taskUUID) = task {
            subject.cancelLoad(forUUID: taskUUID)
        }

        wait(for: [testExpectation], timeout: 1.0)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, expect)
    }

    func test_GivenAnInvalidUrl_WhenGetImage_ThenReturnError() {
        let urlString = ""
        let expect = ImageOrTask.error("URL[] not valid")
        let result = subject.getImage(fromLocation: urlString) { _ in }
        XCTAssertEqual(result, expect)
    }
}
