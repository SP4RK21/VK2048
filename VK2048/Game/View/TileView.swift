//
//  TileView.swift
//  VK2048
//
//  Created by SP4RK on 10/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

class TileView: CellView {
    
    private var value: Int {
        didSet {
            valueLabel?.text = String(value)
            backgroundColor = App.GameElements.tile(value).color
            valueLabel?.textColor = App.GameElements.tileFontColor(value).color
        }
    }
    var valueLabel: UILabel?
    
    init(position: Position, value: Int, frame: CGRect) {
        self.value = value
        super.init(position: position, backgroundColor: App.GameElements.tile(value).color, frame: frame)
        let labelToTileRatio = App.SizeRatio.tileLabelSizeToTileSize
        valueLabel = UILabel(frame: CGRect(origin: .zero,
                                           size: CGSize(width: bounds.width * labelToTileRatio, height: bounds.height * labelToTileRatio))
                                            .offsetBy(dx: bounds.height * (1 - labelToTileRatio) / 2,
                                                      dy: bounds.height * (1 - labelToTileRatio) / 2))
        addSubview(valueLabel!)
        valueLabel?.basicTextSetup(font: UIFont.systemFont(ofSize: frame.height * App.SizeRatio.fontSizeToTileSize, weight: .heavy),
                              fontColor: App.GameElements.tileFontColor(value).color,
                              text: String(value))
    }
    /**
     Sets value displayed on tile to given parametr
     
     - Parameter value: The value to set.
     */
    func setValue(_ value: Int) {
        self.value = value
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
