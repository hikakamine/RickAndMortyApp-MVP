import Foundation

protocol CharactersListPresenterDelegate: AnyObject {

    func presentCharacters(charactersList: [Character])
    func presentErrorMessage(message: String)
}
