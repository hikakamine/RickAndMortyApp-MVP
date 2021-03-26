import Foundation

protocol CharactersListPresenterDelegate: AnyObject {

    func presentCharacters(isNewSearch newSearch: Bool)
    func presentErrorMessage(message: String)
}
