import XCTest
@testable import RickAndMortyApp

// MARK: - Test setup
class CharactersFilterTests: XCTestCase {

    var subject: CharactersFilter!

    override func setUp() {
        super.setUp()
    }
}

// MARK: - Tests

extension CharactersFilterTests {

    func test_GivenNoFilters_WhenGetURL_ThenReturnURLWithoutQueryItems() {
        subject = CharactersFilter()
        let result = subject.url
        let expect = URL(string: "https://rickandmortyapi.com/api/character")
        XCTAssertNotNil(result)
        XCTAssertEqual(expect, result)
    }

    func test_GivenAllFilters_WhenGetURL_ThenReturnURLWithQueryItems() {
        subject = CharactersFilter(name: "Rick", status: "Alive", gender: "Male")
        let result = subject.url
        let expect = URL(string: "https://rickandmortyapi.com/api/character?name=Rick&status=Alive&gender=Male")
        XCTAssertNotNil(result)
        XCTAssertEqual(expect, result)
    }

    func test_GivenAFilterWithSpacesInName_WhenGetURL_ThenReturnURLWithQueryItems() {
        subject = CharactersFilter(name: " Rick ", status: "", gender: "")
        let result = subject.url
        let expect = URL(string: "https://rickandmortyapi.com/api/character?name=Rick")
        XCTAssertNotNil(result)
        XCTAssertEqual(expect, result)
    }

    func test_GivenTwoEqualSubjects_WhenComparingEachOther_ThenReturnEquals() {
        let subject1 = CharactersFilter(name: "rick", status: "alive", gender: "male")
        let subject2 = CharactersFilter(name: "Rick", status: "Alive", gender: "Male")
        let result = subject1 == subject2
        XCTAssertTrue(result)
        XCTAssertEqual(subject1, subject2)
    }

    func test_GivenTwoSubjectsWithSpaces_WhenComparingEachOther_ThenReturnEquals() {
        let subject1 = CharactersFilter(name: " rick ", status: "", gender: "")
        let subject2 = CharactersFilter(name: "rick", status: "", gender: "")
        let result = subject1 == subject2
        XCTAssertTrue(result)
        XCTAssertEqual(subject1, subject2)
    }

    func test_GivenTwoDifferentSubjects_WhenComparingEachOther_ThenReturnDifferent() {
        let subject1 = CharactersFilter(name: "Morty", status: "Alive", gender: "Male")
        let subject2 = CharactersFilter(name: "Rick", status: "Alive", gender: "Male")
        let result = subject1 != subject2
        XCTAssertTrue(result)
        XCTAssertNotEqual(subject1, subject2)
    }
}
