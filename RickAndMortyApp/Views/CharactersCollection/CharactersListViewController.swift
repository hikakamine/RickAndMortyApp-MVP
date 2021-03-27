import UIKit

class CharactersListViewController: UIViewController {

    // MARK: Properties

    private let reuseIdentifier = "CharacterViewCell"

    private let layoutConstants = LayoutConstants.CharactersCollection()

    private var presenter: CharactersListPresenterProtocol!

    private var collectionView: UICollectionView!

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupFilterButton()
        setupCollectionView()
        setupPresenter()
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
        presenter = CharactersListPresenter(network: NetworkService(),
                                            presenterDelegate: self)
        presenter.searchCharacters()
    }
}

// MARK: - Actions
extension CharactersListViewController {

    @objc private func filterButtonPressed() {
        let characterFilterViewController = CharacterFilterViewController()
        characterFilterViewController.parentPresenter = presenter as! CharactersListPresenter
        let navigationCharacterFilterController = UINavigationController(rootViewController: characterFilterViewController)
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

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > (scrollView.contentSize.height - scrollView.bounds.height - 60) {
            presenter.loadNextCharactersPage()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CharactersListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return layoutConstants.collectionCellViewSize(widthSize: view.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return layoutConstants.sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return layoutConstants.sectionInsets.left
    }
}

// MARK: - CharactersListPresenterDelegate
extension CharactersListViewController: CharactersListPresenterDelegate {

    func presentCharacters(isNewSearch newSearch: Bool) {
        DispatchQueue.main.async {
            if newSearch {
                self.collectionView.resetScrollPosition()
            }
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
