//
//  FieldElement.swift
//  VK2048
//
//  Created by SP4RK on 10/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

class CellView: UIView {

    var position: Position

    init(position: Position, backgroundColor: UIColor, frame: CGRect) {
        self.position = position
        super.init(frame: frame)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = App.tileCornerRadius
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

