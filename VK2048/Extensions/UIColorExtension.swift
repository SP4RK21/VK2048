//
//  UIColorExtension.swift
//  VK2048
//
//  Created by SP4RK on 19/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red) / 255
        let newGreen = CGFloat(green) / 255
        let newBlue = CGFloat(blue) / 255
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
