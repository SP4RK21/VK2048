//
//  GameView.swift
//  VK2048
//
//  Created by SP4RK on 19/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

class GameView: UIView {
    
    private let restartButton: RestartButton
    private let gameBoardView: BoardView
    weak var delegate: GameViewDelegate?
    
    init() {
        restartButton = RestartButton()
        gameBoardView = BoardView()
        super.init(frame: .zero)
        initViews()
        setupConstraints()
        setupGestures()
    }
    /**
     Sends specified changes to board to display them
     
     - Parameter changes: array of changes that need to be displayed on board
     */
    func putInBoardDisplayQueue(changesBlock changes: [BoardChange]) {
        gameBoardView.putInDisplayQueue(changesBlock: changes)
    }
    
    private func initViews() {
        self.backgroundColor = App.GameElements.background.color
        addSubview(restartButton)
        addSubview(gameBoardView)
        restartButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        restartButton.anchor(top: nil, bottom: safeBottomAnchor,
                              centerX: safeCenterXAnchor, centerY: nil,
                              size: CGSize(width: restartButton.frame.width, height: restartButton.frame.height),
                              padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: App.spacingFromScreenBorder, right: 0.0))
        let centerLayoutGuide = UILayoutGuide()
        addLayoutGuide(centerLayoutGuide)
        centerLayoutGuide.anchor(top: safeTopAnchor, bottom: restartButton.topAnchor)
        gameBoardView.anchor(top: nil, bottom: nil,
                         centerX: safeCenterXAnchor, centerY: centerLayoutGuide.centerYAnchor,
                         size: CGSize(width: App.boardWidthHeight, height: App.boardWidthHeight))
        
    }
    
    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightAction))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
        swipeLeft.direction = .left
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpAction))
        swipeUp.direction = .up
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownAction))
        swipeDown.direction = .down
        
        addGestureRecognizer(swipeDown)
        addGestureRecognizer(swipeUp)
        addGestureRecognizer(swipeLeft)
        addGestureRecognizer(swipeRight)
    }
    
    @objc private func swipeUpAction() {
        delegate?.didUserSwipeUp()
    }
    @objc private func swipeLeftAction() {
        delegate?.didUserSwipeLeft()
    }
    @objc private func swipeRightAction() {
        delegate?.didUserSwipeRight()
    }
    @objc private func swipeDownAction() {
        delegate?.didUserSwipeDown()
    }
    
    @objc private func restartGame(_ sender: UIButton!) {
        generateTapticFeedback()
        UIView.animate(
            withDuration: App.clickAnimationDuration / 2,
            animations: {
                sender.transform = CGAffineTransform.identity.scaledBy(x: App.buttonClickScaleRatio, y: App.buttonClickScaleRatio)
            },
            completion: { finished in
                self.gameBoardView.putInDisplayQueue(changesBlock: [.restartByButtonClick])
                self.delegate?.shouldRestartGame()
                UIView.animate(
                    withDuration: App.clickAnimationDuration / 2,
                    animations: {
                        sender.transform = CGAffineTransform.identity
                    }
                )
            }
        )
    }
    
    private func generateTapticFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
