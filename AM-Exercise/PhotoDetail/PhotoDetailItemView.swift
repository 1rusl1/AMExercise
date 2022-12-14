//
//  KeyValueView.swift
//  AM-Exercise
//
//  Created by Руслан Сабиров on 16/10/2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import Foundation
import UIKit

extension PhotoDetailItemView {
    struct ViewModel {
        let name: NSAttributedString
        let value: NSAttributedString
    }
}

class PhotoDetailItemView: UIView {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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
        addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(valueLabel)
    }
    
    private func makeConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure(with viewModel: ViewModel) {
        nameLabel.attributedText = viewModel.name
        valueLabel.attributedText = viewModel.value
    }
}
