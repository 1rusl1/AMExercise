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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    private var activeTask: CancellableTask?
    
    private let networkClient = NetworkClient()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(photo: Photo) {
        label.text = photo.id
        
        activeTask = networkClient.fetchImage(on: photo.previewURL) { [weak self] result in
            guard case let .success(image) = result else {
                return
            }
            self?.imageView.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activeTask?.cancel()
    }
}
