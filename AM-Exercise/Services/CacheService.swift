//
//  CacheService.swift
//  AM-Exercise
//
//  Created by Руслан Сабиров on 15/10/2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import Foundation
import UIKit

protocol CacheService {
    func save(image: UIImage, with id: Int)
    func loadImage(with id: Int) -> UIImage?
}

final class PhotoCacheService: CacheService {
    private let cache = NSCache<NSString, UIImage>()
    
    func save(image: UIImage, with id: Int) {
        let stringId = NSString(string: "\(id)")
        if cache.object(forKey: stringId) != nil {
            return
        } else {
            cache.setObject(image, forKey: stringId)
            print("id \(id) сохранено в КЭШ")
        }
    }
    
    func loadImage(with id: Int) -> UIImage?  {
        let stringId = NSString(string: "\(id)")
        return cache.object(forKey: stringId)
    }
}
