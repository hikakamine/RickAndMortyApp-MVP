import UIKit

class CharactersListViewController: UIViewController {

    // MARK: Properties

    private let layoutConstants = LayoutConstants.CharactersCollection()

    private var presenter: CharactersListPresenterProtocol!

    private var collectionView: UICollectionView!

    private var loadingFooterView: LoadingReusableView?

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
                                forCellWithReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier)
        collectionView.register(LoadingReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: LoadingReusableView.reuseIdentifier)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as! CharacterCollectionViewCell
        presenter.setCharacterCell(withCellDelegate: cell,
                                   characterAtRow: indexPath.row)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: LoadingReusableView.reuseIdentifier,
                                                                             for: indexPath) as! LoadingReusableView
            loadingFooterView = footerView
            return footerView
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate
extension CharactersListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == presenter.charactersCount - layoutConstants.itemsPerRow && presenter.isNetworkIdle {
            presenter.loadNextCharactersPage()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String,
                        at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            loadingFooterView?.startAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplayingSupplementaryView view: UICollectionReusableView,
                        forElementOfKind elementKind: String,
                        at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            loadingFooterView?.stopAnimating()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CharactersListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return layoutConstants.collectionCellViewSize(widthSize: collectionView.frame.width)
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


    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        if presenter.hasNextPage {
            return layoutConstants.loadingViewSize(widthSize: collectionView.frame.width)
        }
        return .zero
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
