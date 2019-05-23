//
//  TryAgainButton.swift
//  VK2048
//
//  Created by SP4RK on 12/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

class RestartButton: UIButton {

    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: App.buttonWidth,
                                                             height: App.buttonHeight)))
        backgroundColor = App.GameElements.button.color
        setTitle(App.tryAgainText, for: .normal)
        setTitleColor(App.GameElements.buttonText.color, for: .normal)
        titleLabel?.basicTextSetup(font: UIFont.boldSystemFont(ofSize: frame.height * App.SizeRatio.fontSizeToButtonSize))
        setupShadow()
    }
    
    private func setupShadow() {
        layer.cornerRadius = App.buttonCornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = App.buttonShadowOffset
        layer.shadowOpacity = App.buttonShadowOpacity
        layer.shadowRadius = App.buttonShadowRadius
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
