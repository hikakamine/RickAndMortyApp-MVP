import Foundation

class CharactersListPresenter {

    private var characters = [CharacterData]()
    private var currentFilter: CharactersFilter
    private var networkService: NetworkServiceProtocol
    private weak var presenterDelegate: CharactersListPresenterDelegate?

    init(networkService: NetworkServiceProtocol,
         presenterDelegate: CharactersListPresenterDelegate?) {
        self.currentFilter = CharactersFilter()
        self.networkService = networkService
        self.presenterDelegate = presenterDelegate
    }
}

// MARK: CharactersListPresenterProtocol
extension CharactersListPresenter: CharactersListPresenterProtocol {
    var charactersCount: Int {
        get { characters.count }
    }

    func downloadCharacters() {
        guard let url = currentFilter.url else {
            return
        }
        networkService.downloadCharacters(fromURL: url) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenterDelegate?.presentErrorMessage(message: error.message)
            case .success(let resultData):
                self?.characters.append(contentsOf: resultData.results)
                self?.presenterDelegate?.presentCharacters()
            }
        }
    }

    func setCharacterCell(withCellDelegate delegate: CharacterCollectionCellDelegate,
                          characterAtRow index: Int) {
        let character = characters[index]
        delegate.setCharacterData(withData: character)
        delegate.setCharacterImage(fromData: Data())
    }
}

// MARK: CharactersFilterParentDelegate
extension CharactersListPresenter: CharactersFilterParentDelegate {
    var charactersFilter: CharactersFilter {
        currentFilter
    }

    func reloadList(withNewFilter newFilter: CharactersFilter) {
        if currentFilter != newFilter {
            currentFilter = newFilter
            characters.removeAll()
            downloadCharacters()
        }
    }
}
