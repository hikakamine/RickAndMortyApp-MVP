import Foundation

enum FilterType: Int {
    case status
    case gender
}

protocol CharactersFilterPresenterProtocol: AnyObject {

    func clearFilter()
    func presentFilterValues()
    func getCharactersFilter() -> CharactersFilter
    func searchCharacters()
    func optionsCount(forFilter filter: FilterType) -> Int
    func optionTitle(forFilter filter: FilterType,
                     inRow row: Int) -> String
    func set(filter: FilterType,
             withValueInRow row: Int)
}
