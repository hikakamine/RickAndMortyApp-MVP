import UIKit

class CharactersListViewController: UIViewController {

    // MARK: Properties

    private let reuseIdentifier = "CharacterViewCell"

    private let sectionInsets = LayoutConstants.sectionInsets

    private var itemsPerRow: CGFloat { get { LayoutConstants.itemsPerRow } }

    private var collectionView: UICollectionView!

    private var presenter: CharactersListPresenterProtocol!

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupFilterButton()
        setupCollectionView()
        setupPresenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.downloadCharacters()
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.frame.size = size
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
}

// MARK: - Layout setup
extension CharactersListViewController {

    private func setupNavigationBar() {
        title = "Characters"
    }

    private func setupFilterButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(filterButtonPressed))
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
                                            imagesLoader: ImagesService(),
                                            presenterDelegate: self)
    }
}

// MARK: - Actions
extension CharactersListViewController {

    @objc private func filterButtonPressed() {
        let characterFilterViewController = CharacterFilterViewController()
        characterFilterViewController.parentPresenter = presenter as! CharactersListPresenter
        let navigationCharacterFilterController = UINavigationController(rootViewController: characterFilterViewController)
        navigationCharacterFilterController.modalPresentationStyle = .fullScreen
        present(navigationCharacterFilterController,
                animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension CharactersListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return presenter.charactersCount
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! CharacterCollectionViewCell
        presenter.setCharacterCell(withCellDelegate: cell,
                                   characterAtRow: indexPath.row)
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

    func presentCharacters() {
        DispatchQueue.main.async {
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
