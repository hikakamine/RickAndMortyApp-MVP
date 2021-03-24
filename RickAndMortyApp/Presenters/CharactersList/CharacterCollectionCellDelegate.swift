import Foundation

protocol CharacterCollectionCellDelegate: AnyObject {

    func setCharacterData(withData character: CharacterData)
    func setCharacterImage(fromData data: Data)
}
