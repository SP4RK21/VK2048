//
//  ViewController.swift
//  VK2048
//
//  Created by SP4RK on 09/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

class Game2048Controller: UIViewController {
    
    private var gameModel: Game2048!
    private var gameView = GameView()
    
    override func loadView() {
        view = gameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateOnNotification(_:)),
                                               name: .modelDidChange,
                                               object: gameModel)
        gameModel = Game2048()
        gameView.delegate = self
        gameModel.startGame()
    }
    
    @objc private func updateOnNotification(_ notification: Notification) {
        if let notificationData = notification.userInfo {
            gameView.putInBoardDisplayQueue(changesBlock: notificationData["boardChanges"] as! [BoardChange])
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: - GameViewDelegate
extension Game2048Controller: GameViewDelegate {
    func shouldRestartGame() {
        gameModel.restartGame()
    }
    func didUserSwipeUp() {
        gameModel.moveTiles(to: .up)
    }
    func didUserSwipeDown() {
        gameModel.moveTiles(to: .down)
    }
    func didUserSwipeLeft() {
        gameModel.moveTiles(to: .left)
    }
    func didUserSwipeRight() {
        gameModel.moveTiles(to: .right)
    }
}
