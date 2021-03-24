import Foundation

protocol CharactersListPresenterProtocol: AnyObject {
    var charactersCount: Int { get }

    func downloadCharacters()
    func setCharacterCell(withCellDelegate delegate: CharacterCollectionCellDelegate,
                          characterAtRow index: Int)
}
