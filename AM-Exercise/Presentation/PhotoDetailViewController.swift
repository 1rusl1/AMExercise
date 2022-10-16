//
//  PhotoDetailViewController.swift
//  AM-Exercise
//
//  Created by Руслан Сабиров on 16/10/2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import Foundation
import UIKit

final class PhotoDetailViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Detail"
        return label
    }()
    
    private let keyValueContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 20
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(keyValueContainer)
    }
    
    private func makeConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        keyValueContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            keyValueContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            keyValueContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            keyValueContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func configure(with viewModels: [KeyValueView.ViewModel]) {
        keyValueContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        viewModels.forEach { viewModel in
            let view = KeyValueView()
            view.configure(with: viewModel)
            keyValueContainer.addArrangedSubview(view)
        }
        view.setNeedsLayout()
    }
}
