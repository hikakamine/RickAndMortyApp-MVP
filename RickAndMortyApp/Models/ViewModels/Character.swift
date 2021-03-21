import UIKit

struct Character {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: String
    let location: String
    var image: UIImage?
}

extension Character {

    static func map(fromData data: CharacterData) -> Character {
        return Character(id: data.id,
                         name: data.name,
                         status: data.status,
                         species: data.species,
                         type: data.type,
                         gender: data.gender,
                         origin: data.origin.name,
                         location: data.location.name,
                         image: nil)
    }

    mutating func setImage(_ image: UIImage) {
        self.image = image
    }
}
