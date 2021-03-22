import Foundation

class CharactersListPresenter {

    private var networkService: NetworkServiceProtocol
    private weak var presenterDelegate: CharactersListPresenterDelegate?

    init(networkService: NetworkServiceProtocol,
         presenterDelegate: CharactersListPresenterDelegate?) {
        self.networkService = networkService
        self.presenterDelegate = presenterDelegate
    }

}

extension CharactersListPresenter: CharactersListPresenterProtocol {

    func downloadCharacters(filteredByName name: String = "") {
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        networkService.downloadCharacters(fromURL: url) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenterDelegate?.presentErrorMessage(message: error.message)
            case .success(let resultData):
                let characters = map(charactersData: resultData.results)
                self?.presenterDelegate?.presentCharacters(charactersList: characters)
            }
        }
    }
}

fileprivate func map(charactersData data:[CharacterData]) -> [Character] {
    var characters = [Character]()
    for item in data {
        characters.append(Character.map(fromData: item))
    }
    return characters
}
