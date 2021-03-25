import Foundation

protocol CharacterCollectionCellDelegate: AnyObject {
    var onCellReuse: () -> () { get set }

    func setCharacterData(withData character: CharacterData)
    func setCharacterImage(fromData data: Data)
}
