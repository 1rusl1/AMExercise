//
//  PhotoCell.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    private var activeTask: CancellableTask?
    
    private let networkClient = NetworkClient()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
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
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    func configure(photo: Photo) {
        addSubviews()
        makeConstraints()
        authorLabel.text = photo.user
        idLabel.text = "\(photo.id)"
        
        activeTask = networkClient.fetchImage(on: photo.previewURL) { [weak self] result in
            guard case let .success(image) = result else {
                return
            }
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activeTask?.cancel()
    }
}

extension PhotoCell {
    public static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
