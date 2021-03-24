import Foundation

protocol CharactersFilterParentDelegate: AnyObject {
    var charactersFilter: CharactersFilter { get }

    func reloadList(withNewFilter newFilter: CharactersFilter)
}
