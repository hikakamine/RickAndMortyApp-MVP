import Foundation

protocol CharactersListPresenterDelegate: AnyObject {

    func presentCharacters()
    func presentErrorMessage(message: String)
}
