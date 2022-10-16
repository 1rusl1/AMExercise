//
//  Photo.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import Foundation
import UIKit

struct Photo: Decodable {
    let id: Int
    let user: String
    let comments: Int
    let downloads: Int
    let views: Int
    let likes: Int
    let previewURL: String
    let tags: String
}
