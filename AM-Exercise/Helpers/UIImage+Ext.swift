//
//  UIImageView+Ext.swift
//  AM-Exercise
//
//  Created by Руслан Сабиров on 16/10/2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import UIKit

extension UIImage{
    var roundedImage: UIImage? {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: 5
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
