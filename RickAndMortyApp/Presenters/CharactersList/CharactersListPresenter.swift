import Foundation

class CharactersListPresenter {
    private var characters = [CharacterData]()
    private var nextPage: URL?
    private var currentTask: URLSessionTask?
    private var currentFilter: CharactersFilter
    private var apiServices: ApiProtocol
    private var imagesLoader: ImagesLoader
    private weak var presenterDelegate: CharactersListPresenterDelegate?

    init(network: NetworkProtocol,
         presenterDelegate: CharactersListPresenterDelegate?) {
        self.currentFilter = CharactersFilter()
        self.apiServices = RickAndMortyApi(network: network)
        self.imagesLoader = ImagesService(network: network)
        self.presenterDelegate = presenterDelegate
    }
}

// MARK: CharactersListPresenterProtocol
extension CharactersListPresenter: CharactersListPresenterProtocol {
    var charactersCount: Int {
        get { characters.count }
    }

    var isNetworkIdle: Bool {
        get { currentTask == nil }
    }

    func searchCharacters() {
        guard isNetworkIdle else { return }
        guard let url = currentFilter.url else { return }

        downloadData(from: url)
    }

    func loadNextCharactersPage() {
        guard isNetworkIdle else { return }
        guard let url = nextPage else { return }

        downloadData(from: url, isNewSearch: false)
    }

    func setCharacterCell(withCellDelegate delegate: CharacterCollectionCellDelegate,
                          characterAtRow index: Int) {
        let character = characters[index]
        delegate.setCharacterData(withData: character)

        let token = imagesLoader.getImage(at: character.image) { data in
            delegate.setCharacterImage(fromData: data)
        }
        delegate.onCellReuse = {
            if let token = token {
                self.imagesLoader.cancelLoad(forUUID: token)
            }
        }
    }
}

// MARK: - Private methods
extension CharactersListPresenter {

    private func downloadData(from url: URL,
                              isNewSearch newSearch: Bool = true) {
        currentTask = apiServices.downloadCharacters(fromURL: url) { [unowned self] response in
            switch response {
            case .failure(let error):
                self.presenterDelegate?.presentErrorMessage(message: error.localizedDescription)
            case .success(let result):
                self.setCharactersData(result: result,
                                       isNewSearch: newSearch)
                self.presenterDelegate?.presentCharacters(isNewSearch: newSearch)
            }
            self.currentTask = nil
        }
    }

    private func setCharactersData(result data: ResultData<CharacterData>,
                                   isNewSearch newSearch: Bool) {
        if newSearch {
            characters = data.results
        } else {
            characters.append(contentsOf: data.results)
        }

        if let next = data.info.next, let nextURL = URL(string: next) {
            nextPage = nextURL
        } else {
            nextPage = nil
        }
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
            searchCharacters()
        }
    }
}
