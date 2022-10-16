//
//  PhotoProvider.swift
//  AM-Exercise
//
//  Created by Руслан Сабиров on 15/10/2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import Foundation
import UIKit

final class ImageProvider {
    private let cacheService = PhotoCacheService()
    
    private let networkClient = NetworkClient()
    
    static let shared = ImageProvider()
    
    private init() { }
    
    func provideImageForPhoto(_ photo: Photo, completion:@escaping (Result<UIImage?, Error>) -> Void) -> CancellableTask? {
        guard let cachedImage = cacheService.loadImage(with: photo.id) else {
            let task = networkClient.fetchImage(on: photo.previewURL) { [weak self] result in
                switch result {
                case let .success(image):
                    self?.cacheService.save(image: image, with: photo.id)
                    completion(.success(image))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
            return task
        }
        completion(.success(cachedImage))
        return nil
    }
}
