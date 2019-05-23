//
//  UILabelExtension.swift
//  VK2048
//
//  Created by SP4RK on 19/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

extension UILabel {
    func basicTextSetup(font: UIFont, fontColor: UIColor? = nil, text: String? = nil) {
        if let text = text {
            self.text = text
        }
        if let fontColor = fontColor {
            textColor = fontColor
        }
        textAlignment =  .center
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.03
        numberOfLines = 1
        baselineAdjustment = .alignCenters
        self.font = font
    }
}
