import Foundation

protocol CharactersFilterPresenterDelegate: AnyObject {

    func getNameText() -> String
    func setNameTextField(withText text: String)
    func setStatusTextField(withText text: String)
    func setGenderTextField(withText text: String)
}
