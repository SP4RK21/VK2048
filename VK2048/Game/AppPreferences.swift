//
//  App.swift
//  VK2048
//
//  Created by SP4RK on 10/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

enum App {
    // MARK: General game settings
    static var boardDimension = 4
    static var numberOfInitialTiles = 2
    static var luckyChanceOfValue4 = 0.1
    
    // MARK: Animations length
    static var clickAnimationDuration = 0.2
    static var moveAnimationDuration = 0.07
    static var boardRestartAnimationDuration = 0.2
    static var addAnimationDuration = 0.15
    static var mergeScaleAnimationDuration = 0.1
    
    // MARK: Animations preferences
    static var wrongMoveDelta: CGFloat = SizeRatio.wrongMoveDeltaToTileSize * tileSize
    static var scaleUpTransform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
    static var scaleDownTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
    static var buttonClickScaleRatio: CGFloat = 0.9
    
    // MARK: Button preferences
    static var tryAgainText = "Попробовать ещё раз"
    static var buttonShadowOpacity: Float = 0.2
    static var buttonShadowRadius: CGFloat = spacingFromScreenBorder
    static var buttonShadowOffset = CGSize(width: 0.0, height: 12.0)
    
    // MARK: Sizes and spacings
    static let spacingFromScreenBorder = SizeRatio.spacingFromScreenBorderToScreenWidth * UIScreen.main.bounds.width
    static let spacingBetweenTiles = SizeRatio.spacingBetweenTilesToSpacingFromScreenBorder * spacingFromScreenBorder
    static let tileCornerRadius = SizeRatio.cornerRadiusToTileSize * tileSize
    static let buttonCornerRadius = SizeRatio.cornerRadiusToButtonHeight * buttonHeight
    static let boardWidthHeight = UIScreen.main.bounds.width - 2 * spacingFromScreenBorder
    static let tileSize = (boardWidthHeight - CGFloat(boardDimension - 1) * spacingBetweenTiles) / CGFloat(boardDimension)
    static let buttonWidth = SizeRatio.buttonWidthToScreenWidth * UIScreen.main.bounds.width
    static let buttonHeight = SizeRatio.buttonHeightToButtonWidth *  buttonWidth
    
    
    // MARK: Size ratios
    enum SizeRatio {
        static let spacingBetweenTilesToSpacingFromScreenBorder: CGFloat = 0.5
        static let spacingFromScreenBorderToScreenWidth: CGFloat = 0.043
        static let wrongMoveDeltaToTileSize: CGFloat = 0.1
        static let buttonHeightToButtonWidth: CGFloat = 0.192
        static let buttonWidthToScreenWidth: CGFloat = 0.496
        static let fontSizeToButtonSize: CGFloat = 0.4
        static let cornerRadiusToTileSize: CGFloat = 0.15
        static let cornerRadiusToButtonHeight: CGFloat = 0.3
        static let fontSizeToTileSize: CGFloat = 0.47
        static let tileLabelSizeToTileSize: CGFloat = 0.64
    }
    
    // MARK: Colors for game elements
    enum GameElements {
        var color: UIColor {
            switch self {
            case .background: return UIColor(red: 242, green: 243, blue: 245)
            case .emptyCell: return UIColor(red: 186, green: 193, blue: 203)
            case let .tile(value):
                switch value {
                case 2: return UIColor.white
                case 4: return UIColor(red: 225, green: 227, blue: 230)
                case 8: return UIColor(red: 167, green: 220, blue: 251)
                case 16: return UIColor(red: 112, green: 178, blue: 249)
                case 32: return UIColor(red: 63, green: 138, blue: 228)
                case 64: return UIColor(red: 37, green: 102, blue: 207)
                case 128: return UIColor(red: 24, green: 75, blue: 177)
                case 256: return UIColor(red: 34, green: 63, blue: 128)
                case 512: return UIColor(red: 17, green: 45, blue: 128)
                case 1024: return UIColor(red: 0, green: 34, blue: 177)
                case 2048: return UIColor(red: 13, green: 13, blue: 107)
                default: return UIColor.black
                }
            case let .tileFontColor(value):
                switch value {
                case 2: return UIColor.black
                case 4: return UIColor.black
                case 8: return UIColor.black
                case 16: return UIColor.black
                case 32: return UIColor.black
                case 64: return UIColor.white
                case 128: return UIColor.white
                case 256: return UIColor.white
                case 512: return UIColor.white
                case 1024: return UIColor.white
                case 2048: return UIColor.white
                default: return UIColor.white
                }
            case .shadow: return UIColor.black
            case .buttonText: return UIColor(red: 44, green: 45, blue: 46)
            case .button: return UIColor.white
            }
        }
        case background
        case tile(Int)
        case emptyCell
        case tileFontColor(Int)
        case shadow
        case buttonText
        case button
    }
}
