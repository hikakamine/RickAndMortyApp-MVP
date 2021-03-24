import UIKit

class CharacterFilterViewController: UIViewController {

    // MARK: Properties

    private lazy var nameLabel: UILabel = {
        let label = UILabel.newLabel()
        label.text = "Name"
        view.addSubview(label)
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let field = UITextField.newTextField()
        field.inputAccessoryView = doneToolbar
        view.addSubview(field)
        return field
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel.newLabel()
        label.text = "Status"
        view.addSubview(label)
        return label
    }()

    private lazy var statusTextField: UITextField = {
        let field = UITextField.newTextField()
        field.inputView = statusPicker
        field.inputAccessoryView = doneToolbar
        view.addSubview(field)
        return field
    }()

    private lazy var statusPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = FilterType.status.rawValue
        return picker
    }()

    private lazy var genderLabel: UILabel = {
        let label = UILabel.newLabel()
        label.text = "Gender"
        view.addSubview(label)
        return label
    }()

    private lazy var genderTextField: UITextField = {
        let field = UITextField.newTextField()
        field.inputView = genderPicker
        field.inputAccessoryView = doneToolbar
        view.addSubview(field)
        return field
    }()

    private lazy var genderPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = FilterType.gender.rawValue
        return picker
    }()

    private lazy var doneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero,
                                              size: CGSize(width: 100,
                                                           height: 44)))
        let done = UIBarButtonItem(title: "Done",
                                   style: .plain,
                                   target: self,
                                   action: #selector(inputDonePressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        toolbar.setItems([flexibleSpace, done],
                         animated: false)
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }()

    // MARK: Presenters

    private var presenter: CharactersFilterPresenterProtocol!

    var parentPresenter: CharactersFilterParentDelegate?

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationItems()
        setupComponentsLayout()
        setupPresenter()
    }
}

// MARK: - Layout setup
extension CharacterFilterViewController {

    private func setupView() {
        title = "Filter"
        view.backgroundColor = .backgroundColor
    }

    private func setupNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(searchButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(clearButtonPresssed))
    }

    private func setupComponentsLayout() {
        setupNameLabelConstraints()
        setupNameTextFieldConstraints()
        setupStatusLabelConstraints()
        setupStatusTextFieldConstraints()
        setupGenderLabelConstraints()
        setupGenderTextFieldConstraints()
    }

    private func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    private func setupNameTextFieldConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,
                                               constant: 4),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: -16)
        ])
    }

    private func setupStatusLabelConstraints() {
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,
                                             constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -16),
            statusLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    private func setupStatusTextFieldConstraints() {
        NSLayoutConstraint.activate([
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor,
                                                 constant: 4),
            statusTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                     constant: 16),
            statusTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                      constant: -16)
        ])
    }

    private func setupGenderLabelConstraints() {
        NSLayoutConstraint.activate([
            genderLabel.topAnchor.constraint(equalTo: statusTextField.bottomAnchor,
                                             constant: 8),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant: 16),
            genderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -16),
            genderLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    private func setupGenderTextFieldConstraints() {
        NSLayoutConstraint.activate([
            genderTextField.topAnchor.constraint(equalTo: genderLabel.bottomAnchor,
                                                 constant: 4),
            genderTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                     constant: 16),
            genderTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                      constant: -16)
        ])
    }

    private func setupPresenter() {
        presenter = CharactersFilterPresenter(delegate: self,
                                              parentDelegate: parentPresenter)
        presenter.presentFilterValues()
    }
}

// MARK: - Actions
extension CharacterFilterViewController {

    @objc private func searchButtonPressed() {
        dismiss(animated: true) {
            self.presenter.searchCharacters()
        }
    }

    @objc private func clearButtonPresssed() {
        presenter.clearFilter()
    }

    @objc private func inputDonePressed() {
        view.endEditing(true)
    }
}

// MARK: - UIPickerViewDelegate
extension CharacterFilterViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        guard let type = FilterType(rawValue: pickerView.tag) else { return }
        presenter.set(filter: type, withValueInRow: row)
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        guard let type = FilterType(rawValue: pickerView.tag) else { return nil }
        return presenter.optionTitle(forFilter: type, inRow: row)
    }
}

// MARK: - UIPickerViewDataSource
extension CharacterFilterViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        guard let type = FilterType(rawValue: pickerView.tag) else { return 0 }
        return presenter.optionsCount(forFilter: type)
    }
}

// MARK: - CharactersFilterPresenterDelegate
extension CharacterFilterViewController: CharactersFilterPresenterDelegate {

    func getNameText() -> String {
        return nameTextField.text ?? ""
    }

    func setNameTextField(withText text: String) {
        nameTextField.text = text
    }

    func setStatusTextField(withText text: String) {
        statusTextField.text = text
    }

    func setGenderTextField(withText text: String) {
        genderTextField.text = text
    }
}
