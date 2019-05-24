//
//  Board.swift
//  VK2048
//
//  Created by SP4RK on 11/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    private var boardCellsRects: [[CGRect]] = [[]]
    private var boardWithTiles: [TileView] = []
    
    private var changesQueue = Queue<[BoardChange]>()
    private var animationRunning = false
    private var animationsToRun = 0
    private var animationsFinished = 0
    private var animationsSpeedUp = false
    private var moveHappening = false
    
    private var dimension: Int {
        return App.boardDimension
    }
    
    init() {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: App.boardWidthHeight,
                                                                    height: App.boardWidthHeight)))
        fillWithEmptyCells()
    }
    
    /**
     Puts specified changes in queue or directly dispays them if queue is empty and no animations are runinig
     
     - Parameter changesBlock: array of changes that need to be displayed on board
     */
    func putInDisplayQueue(changesBlock: [BoardChange]) {
        if case BoardChange.restartByLoss = changesBlock[0] {
            changesQueue.enqueue(changesBlock)
            return
        }
        if animationsSpeedUp {
            changesQueue.enqueue(changesBlock)
            return
        }
        if changesQueue.count > 2 || moveHappening {
            animationsSpeedUp = true
            while !changesQueue.isEmpty {
                displayChanges(changesQueue.dequeue())
            }
            animationsSpeedUp = false
        }
        if changesQueue.isEmpty && !animationRunning {
            displayChanges(changesBlock)
        } else {
            changesQueue.enqueue(changesBlock)
        }
    }
    
    private func displayChanges(_ changesBlock: [BoardChange]?) {
        if let animations = changesBlock {
            animationsToRun = animations.count
            animationsFinished = 0
            animations.forEach{
                animationRunning = true
                switch $0 {
                    case let .add(tile): add(tile: tile)
                    case let .load(tile): addTileWithoutAnimation(tile)
                    case let .merge(sourceTile, destinationTile): moveHappening = true; merge(tile: sourceTile, with: destinationTile)
                    case let .move(sourceTile, destinationPosition):moveHappening = true; move(tile: sourceTile, to: destinationPosition)
                    case let .wrongMove(direction): wrongMove(direction)
                    case .restartByButtonClick, .restartByLoss: restartBoard()
                }
            }
        }
    }
    
    private func fillWithEmptyCells() {
        var cellOriginPoint = CGPoint(x: 0, y: 0)
        boardCellsRects = Array(repeating: Array(repeating: CGRect.zero, count: dimension), count: dimension)
        for row in 0..<dimension {
            for column in 0..<dimension {
                let emptyCell = CellView(position: Position(row: row, column: column),
                                         backgroundColor: App.GameElements.emptyCell.color,
                                         frame: CGRect(origin: cellOriginPoint,
                                                       size: CGSize(width: App.tileSize, height: App.tileSize)))
                cellOriginPoint.x += App.tileSize + App.spacingBetweenTiles
                addSubview(emptyCell)
                boardCellsRects[row][column] = emptyCell.frame
            }
            cellOriginPoint.x = 0
            cellOriginPoint.y += App.tileSize + App.spacingBetweenTiles
        }
    }
    
    private func restartBoard() {
        boardWithTiles.forEach(){ tileView in
            UIView.animate(
                withDuration: App.boardRestartAnimationDuration,
                animations: {
                    tileView.transform = App.scaleUpTransform
                },
                completion: { halfFinished in
                    UIView.animate(
                        withDuration: App.boardRestartAnimationDuration,
                        animations: {
                            tileView.transform = App.scaleDownTransform
                            tileView.alpha = 0
                        },
                        completion: { finished in
                            tileView.removeFromSuperview()
                            self.finishAnimation()
                        }
                    )
                }
            )
        }
        boardWithTiles.removeAll()
    }
    
    private func addTileWithoutAnimation(_ tile: Tile) {
        let tileToAdd = TileView(position: tile.position,
                                 value: tile.containedValue!,
                                 frame: boardCellsRects[tile.position.row][tile.position.column])
        boardWithTiles.append(tileToAdd)
        addSubview(tileToAdd)
        finishAnimation()
    }
    
    private func add(tile: Tile) {
        let tileToAdd = TileView(position: tile.position,
                                 value: tile.containedValue!,
                                 frame: boardCellsRects[tile.position.row][tile.position.column])
        tileToAdd.transform = App.scaleDownTransform
        tileToAdd.alpha = 0
        boardWithTiles.append(tileToAdd)
        addSubview(tileToAdd)
        UIView.animate(
            withDuration: App.addAnimationDuration * 1.5,
            animations: {
                tileToAdd.transform = .identity
                tileToAdd.alpha = 1.0
            }, completion: { finished in
                self.finishAnimation()
            }
        )
    }
    
    private func move(tile: Tile, to destinationPosition: Position) {
        let sourceTileView = boardWithTiles.filter({$0.position == tile.position}).first!
        sourceTileView.position = destinationPosition
        let animationDuration = App.moveAnimationDuration *
            (Double(max(abs(tile.position.row - destinationPosition.row), abs(tile.position.column - destinationPosition.column))))
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                sourceTileView.frame = self.boardCellsRects[destinationPosition.row][destinationPosition.column]
            },
            completion: { finished in
                self.finishAnimation()
            }
        )
    }
    
    private func merge(tile sourceTile: Tile, with destinationTile: Tile) {
        let sourceTileView = boardWithTiles.filter({$0.position == sourceTile.position}).first!
        let destinationTileView = boardWithTiles.filter({$0.position == destinationTile.position}).first!
        let index = boardWithTiles.firstIndex(of: destinationTileView)!
        sourceTileView.position = destinationTileView.position
        boardWithTiles.remove(at: index)
        bringSubviewToFront(sourceTileView)
        let animationDurationConsideringDistance = App.moveAnimationDuration *
            Double(max(abs(sourceTile.position.row - destinationTile.position.row),
                       abs(sourceTile.position.column - destinationTile.position.column)))
        
        UIView.transition(
            with: sourceTileView.valueLabel!,
            duration: animationDurationConsideringDistance / 1.5,
            options: .transitionCrossDissolve,
            animations: {
                sourceTileView.setValue(destinationTile.containedValue!)
            }
        )
        UIView.animate(
            withDuration: animationDurationConsideringDistance,
            animations: {
                sourceTileView.center = destinationTileView.center
            },
            completion: { finishedMove in
                destinationTileView.removeFromSuperview()
                UIView.animate(
                    withDuration: App.mergeScaleAnimationDuration,
                    delay: 0,
                    options: .curveEaseInOut,
                    animations: {
                        sourceTileView.transform = App.scaleUpTransform
                    },
                    completion: { halfFinishedMergeScale in
                        UIView.animate(
                            withDuration: App.mergeScaleAnimationDuration,
                            delay: 0,
                            options: .curveEaseInOut,
                            animations: {
                                sourceTileView.transform = .identity
                            }, completion: { finished in
                                self.finishAnimation()
                                sourceTileView.frame = self.boardCellsRects[sourceTileView.position.row][sourceTileView.position.column]
                            }
                        )
                    }
                )
            }
        )
    }
    
    private func wrongMove(_ direction: Direction) {
        var deltaMove: CGPoint
        switch direction {
        case .up: deltaMove = CGPoint(x: 0, y: -App.wrongMoveDelta)
        case .down: deltaMove = CGPoint(x: 0, y: App.wrongMoveDelta)
        case .right: deltaMove = CGPoint(x: App.wrongMoveDelta, y: 0)
        case .left: deltaMove = CGPoint(x: -App.wrongMoveDelta, y: 0)
        }
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
        boardWithTiles.forEach(){ tileView in
            UIView.animate(
                withDuration: App.moveAnimationDuration,
                animations: {
                    tileView.frame.origin = tileView.frame.origin + deltaMove
                },
                completion: { halfFinished in
                    UIView.animate(
                        withDuration: App.moveAnimationDuration,
                        animations: {
                            tileView.frame.origin = tileView.frame.origin - deltaMove
                        },
                        completion: { finished in
                            self.finishAnimation()
                            tileView.frame = self.boardCellsRects[tileView.position.row][tileView.position.column]
                        }
                    )
                }
            )
        }
    }
    
    private func finishAnimation() {
        animationsFinished += 1
        if animationsFinished == animationsToRun {
            animationRunning = false
            moveHappening = false
            displayChanges(changesQueue.dequeue())
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

enum BoardChange {
    case add(Tile)
    case load(Tile)
    case move(Tile, Position)
    case merge(Tile, Tile)
    case wrongMove(Direction)
    case restartByLoss
    case restartByButtonClick
}
