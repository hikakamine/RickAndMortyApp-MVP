import Foundation

class CharactersListPresenter {
    private let apiServices: ApiProtocol
    private let imagesLoader: ImagesLoader

    private var characters = [CharacterData]()
    private var nextPage: URL?
    private var currentTask: URLSessionTask?
    private var currentFilter: CharactersFilter

    private weak var presenterDelegate: CharactersListPresenterDelegate?

    init(network: NetworkProtocol,
         presenterDelegate: CharactersListPresenterDelegate?) {
        self.apiServices = RickAndMortyApi(network: network)
        self.imagesLoader = ImagesService(network: network)
        self.currentFilter = CharactersFilter()
        self.presenterDelegate = presenterDelegate
    }
}

// MARK: - CharactersListPresenterProtocol
extension CharactersListPresenter: CharactersListPresenterProtocol {
    var charactersCount: Int {
        get { characters.count }
    }

    var isNetworkIdle: Bool {
        get { currentTask == nil }
    }

    var hasNextPage: Bool {
        get { nextPage != nil }
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
        setCharacterDetails(withCellDelegate: delegate,
                            fromCharacterData: character)
        setCharacterImage(withCellDelegate: delegate,
                          fromImageURL: character.image)
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

    private func setCharacterDetails(withCellDelegate delegate: CharacterCollectionCellDelegate,
                                     fromCharacterData character: CharacterData) {
        delegate.setCharacterData(withData: character)
    }

    private func setCharacterImage(withCellDelegate delegate: CharacterCollectionCellDelegate,
                                   fromImageURL imageURL: String) {
        let imageOrTask = imagesLoader.getImage(fromLocation: imageURL) { imageResult in
            if case .image(let data) = imageResult {
                DispatchQueue.main.async {
                    delegate.setCharacterImage(fromData: data)
                }
            }
        }
        switch imageOrTask {
        case .image(let data):
            delegate.setCharacterImage(fromData: data)
        case .task(let taskUUID):
            delegate.onCellReuse = {
                self.imagesLoader.cancelLoad(forUUID: taskUUID)
            }
        case .error(let error):
            print(error)
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
