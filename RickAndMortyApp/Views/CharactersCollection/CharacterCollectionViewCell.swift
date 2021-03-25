import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {

    // MARK: Properties

    lazy var characterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = LayoutConstants.cornerRadius
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        return imageView
    }()

    lazy var characterStatusLabel: UILabel = {
        let label = UILabel.newLabel(fontSize: 8,
                                     fontColor: .subtitleColor)
        addSubview(label)
        return label
    }()

    lazy var characterNameLabel: UILabel = {
        let label = UILabel.newLabel()
        addSubview(label)
        return label
    }()

    private var onReuse: () -> () = {}

    // MARK: View Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        setupLayer()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        characterImageView.image = nil
    }
}

// MARK: Layout setup
extension CharacterCollectionViewCell {

    private func setupConstraints() {
        setupCharacterNameConstraints()
        setupCharacterStatusConstraints()
        setupCharacterImageConstraints()
    }

    private func setupCharacterImageConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: self.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }

    private func setupCharacterStatusConstraints() {
        NSLayoutConstraint.activate([
            characterStatusLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor,
                                                      constant: 2),
            characterStatusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                          constant: 8),
            characterStatusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                           constant: -8),
            characterStatusLabel.heightAnchor.constraint(equalToConstant: 8)])
    }

    private func setupCharacterNameConstraints() {
        NSLayoutConstraint.activate([
            characterNameLabel.topAnchor.constraint(equalTo: characterStatusLabel.bottomAnchor,
                                                    constant: 2),
            characterNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                       constant: -4),
            characterNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                        constant: 8),
            characterNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                         constant: -8),
            characterNameLabel.heightAnchor.constraint(equalToConstant: 16)])
    }

    private func setupLayer() {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = LayoutConstants.cornerRadius
    }
}

// MARK: - CharacterCollectionCellPresenterDelegate
extension CharacterCollectionViewCell: CharacterCollectionCellDelegate {
    var onCellReuse: () -> () {
        get { onReuse }
        set { onReuse = newValue }
    }

    func setCharacterData(withData character: CharacterData) {
        characterStatusLabel.text = character.status
        characterNameLabel.text = character.name
    }

    func setCharacterImage(fromData data: Data) {
        DispatchQueue.main.async {
            self.characterImageView.image = UIImage(data: data)
        }
    }
}
