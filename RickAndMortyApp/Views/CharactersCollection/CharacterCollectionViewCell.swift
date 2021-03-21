import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {

    lazy var characterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        return imageView
    }()

    lazy var characterStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .subtitleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 8)
        addSubview(label)
        return label
    }()

    lazy var characterNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .titleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        addSubview(label)
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        setupLayer()
    }

    // MARK: Private methods
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
                                                       constant: -2),
            characterNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                        constant: 8),
            characterNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                         constant: -8),
            characterNameLabel.heightAnchor.constraint(equalToConstant: 16)])
    }

    private func setupLayer() {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 8.0
    }
}
