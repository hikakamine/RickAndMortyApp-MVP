import XCTest
@testable import RickAndMortyApp

// MARK: - Test setup
class CharactersCollectionPresenterTest: XCTestCase {

    var networkMock: NetworkProtocol!
    var subject: CharactersListPresenter!
    var resultDelegate: CharactersListPresenterDelegate!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolStubs.self]
        networkMock = NetworkService(session: URLSession.init(configuration: config))
    }

    func givenNormalConditions() {
        
    }
}

// MARK: - Tests
extension CharactersCollectionPresenterTest {

    func test_Given_When_Then() {
        givenNormalConditions()
    }
}
