import Foundation

protocol CharactersListPresenterProtocol: AnyObject {
    var charactersCount: Int { get }
    var isNetworkIdle: Bool { get }

    func searchCharacters()
    func loadNextCharactersPage()
    func setCharacterCell(withCellDelegate delegate: CharacterCollectionCellDelegate,
                          characterAtRow index: Int)
}
