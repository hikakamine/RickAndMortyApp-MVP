import UIKit

class CharactersListViewController: UIViewController {

    private let reuseIdentifier = "CharacterViewCell"

    private let sectionInsets = UIEdgeInsets(top: 16,
                                             left: 16,
                                             bottom: 16,
                                             right: 16)

    private var itemsPerRow: CGFloat { get { LayoutConstants.itemsPerRow } }

    private lazy var charactersList: [Character] = {
        var list = [Character]()
        for id in 1 ... 20 {
            list.append(Character(id: id,
                                  name: "Rick \(id)",
                                  status: "Alive",
                                  species: "Human",
                                  type: "Human",
                                  gender: "Male",
                                  origin: "Earth",
                                  location: "Earth",
                                  image: UIImage(named: "Rick")))
        }
        return list
    }()

    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        settupCollectionView()
    }

    private func settupCollectionView() {
        collectionView = UICollectionView(frame: view.frame,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.frame.size = size
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
}

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

extension CharactersListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

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

extension CharactersListViewController: CharactersListPresenterDelegate {

    func presentCharacters(charactersList: [Character]) {
        self.charactersList = charactersList
        self.collectionView.reloadData()
    }
}
