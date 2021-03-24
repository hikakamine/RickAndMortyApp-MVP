import XCTest
@testable import RickAndMortyApp

// MARK: - Test setup
class CharactersCollectionPresenterTest: XCTestCase {

    var networkMock: NetworkServiceProtocol!
    var subject: CharactersListPresenter!
    var resultDelegate: CharactersListPresenterDelegate!

    override func setUp() {
//        subject = CharactersListPresenter(networkService: networkMock,
//                                          presenterDelegate: resultDelegate)
    }

    override func tearDown() {

    }
}

// MARK: - Tests
extension CharactersCollectionPresenterTest {

    func test_Given_When_Then() {

    }
}
