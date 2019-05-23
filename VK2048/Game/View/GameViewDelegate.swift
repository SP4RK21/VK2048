//
//  GameViewDelegate.swift
//  VK2048
//
//  Created by SP4RK on 19/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

protocol GameViewDelegate: AnyObject {
    func shouldRestartGame()
    func didUserSwipeUp()
    func didUserSwipeDown()
    func didUserSwipeLeft()
    func didUserSwipeRight()
}
