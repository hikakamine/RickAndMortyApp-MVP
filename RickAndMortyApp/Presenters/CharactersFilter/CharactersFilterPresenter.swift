import Foundation

class CharactersFilterPresenter {

    private let statusList = ["", "Alive", "Dead", "Unknown"]
    private let genderList = ["", "Female", "Male", "Genderless", "Unknown"]

    private weak var delegate: CharactersFilterPresenterDelegate?
    private weak var parentDelegate: CharactersFilterParentDelegate?

    private var characterFilter: CharactersFilter

    init(delegate: CharactersFilterPresenterDelegate,
         parentDelegate: CharactersFilterParentDelegate?) {
        self.delegate = delegate
        self.parentDelegate = parentDelegate
        self.characterFilter = parentDelegate?.charactersFilter ?? CharactersFilter()
    }
}

// MARK: - CharactersFilterPresenterProtocol
extension CharactersFilterPresenter: CharactersFilterPresenterProtocol {

    func clearFilter() {
        characterFilter = CharactersFilter()
        delegate?.setNameTextField(withText: "")
        delegate?.setStatusTextField(withText: "")
        delegate?.setGenderTextField(withText: "")
    }

    func presentFilterValues() {
        delegate?.setNameTextField(withText: characterFilter.name)
        delegate?.setStatusTextField(withText: characterFilter.status)
        delegate?.setGenderTextField(withText: characterFilter.gender)
    }

    func getCharactersFilter() -> CharactersFilter {
        characterFilter.name = delegate?.getNameText() ?? ""
        return characterFilter
    }

    func searchCharacters() {
        parentDelegate?.reloadList(withNewFilter: getCharactersFilter())
    }

    func optionsCount(forFilter filter: FilterType) -> Int {
        switch filter {
        case .status:
            return statusList.count
        case .gender:
            return genderList.count
        }
    }

    func optionTitle(forFilter filter: FilterType,
                     inRow row: Int) -> String {
        let value = getValue(forFilter: filter,
                             inRow: row)
        return value.isEmpty ? "None" : value
    }

    func set(filter: FilterType,
             withValueInRow row: Int) {
        let text = getValue(forFilter: filter,
                            inRow: row)
        switch filter {
        case .status:
            characterFilter.status = text
            delegate?.setStatusTextField(withText: text)
        case .gender:
            characterFilter.gender = text
            delegate?.setGenderTextField(withText: text)
        }
    }

    private func getValue(forFilter filter: FilterType,
                          inRow row: Int) -> String {
        switch filter {
        case .status:
            return statusList[row]
        case .gender:
            return genderList[row]
        }
    }
}
