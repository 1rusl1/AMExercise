//
//  PhotoCell.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import Foundation
import UIKit

extension PhotoCell {
    enum Constants {
        static let imageViewInset: CGFloat = 5
        static let sizeMultiplier: CGFloat = 0.5
    }
}

class PhotoCell: UICollectionViewCell {
    var id = 0
    
    private var activeTask: CancellableTask?
    
    private let imageProvider = ImageProvider.shared
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let idLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        addSubviews()
        makeConstraints()
        imageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        infoStackView.addArrangedSubview(authorLabel)
        infoStackView.addArrangedSubview(idLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(infoStackView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.imageViewInset),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.imageViewInset),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.imageViewInset),
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,constant: Constants.imageViewInset),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Constants.sizeMultiplier),
            authorLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: Constants.sizeMultiplier),
            idLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: Constants.sizeMultiplier)
        ])
    }
    
    func configure(photo: Photo) {
        guard id == photo.id else { return }
        
        authorLabel.text = "Author:\n\(photo.user)"
        idLabel.text = "Photo ID:\n\(photo.id)"
        
        activeTask = imageProvider.provideImageForPhoto(photo, completion: { [weak self] result in
            guard case let .success(image) = result else {
                return
            }
            DispatchQueue.main.async {
                self?.imageView.image = image?.roundedImage
            }
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activeTask?.cancel()
        authorLabel.text = nil
        idLabel.text = nil
        imageView.image = nil
    }
}

extension PhotoCell {
    public static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
