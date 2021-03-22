import UIKit

// MARK: - UIViewController
class CharactersListViewController: UIViewController {

    private let reuseIdentifier = "CharacterViewCell"

    private let sectionInsets = LayoutConstants.sectionInsets

    private var itemsPerRow: CGFloat { get { LayoutConstants.itemsPerRow } }

    private var collectionView: UICollectionView!

    private var presenter: CharactersListPresenterProtocol!

    private var charactersList = [Character]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPresenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.downloadCharacters(filteredByName: "")
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.frame.size = size
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.frame,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
    }

    private func setupPresenter() {
        presenter = CharactersListPresenter(networkService: RickAndMortyAPI(),
                                            presenterDelegate: self)
    }
}

// MARK: - UICollectionViewDataSource
extension CharactersListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return charactersList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! CharacterCollectionViewCell
        let character = charactersList[indexPath.row]
        cell.characterImageView.image = character.image
        cell.characterStatusLabel.text = character.status
        cell.characterNameLabel.text = character.name
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CharactersListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CharactersListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 2)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = (availableWidth / itemsPerRow) + 8
        return CGSize(width: widthPerItem,
                      height: widthPerItem + 32)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - CharactersListPresenterDelegate
extension CharactersListViewController: CharactersListPresenterDelegate {

    func presentCharacters(charactersList: [Character]) {
        DispatchQueue.main.async {
            self.charactersList = charactersList
            self.collectionView.reloadData()
        }
    }

    func presentErrorMessage(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error",
                                          message: message,
                                          preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK",
                                            style: .cancel,
                                            handler: nil)
            alert.addAction(alertAction)
            self.present(alert,
                         animated: true,
                         completion: nil)
        }
    }
}
