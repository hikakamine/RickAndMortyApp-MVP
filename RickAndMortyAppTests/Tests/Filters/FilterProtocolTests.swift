import XCTest
@testable import RickAndMortyApp

// MARK: - FilterTest
struct FilterTest: FilterProtocol {
    var path = "/filter"
    var queryItems: [URLQueryItem] = [URLQueryItem]()
}

// MARK: - Test setup
class FilterProtocolTests: XCTestCase {

    var subject: FilterProtocol!

    override func setUp() {
        super.setUp()
        subject = FilterTest()
    }
}

// MARK: - Tests

extension FilterProtocolTests {

    func test_GivenFilterTest_WhenGetURL_ThenReturnValidURL() {
        let result = subject.url
        XCTAssertNotNil(result)
        let expect = URL(string: "https://rickandmortyapi.com/api/filter")
        XCTAssertEqual(expect, result)
    }
}
