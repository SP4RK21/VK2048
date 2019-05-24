//
//  Game2048.swift
//  VK2048
//
//  Created by SP4RK on 09/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

class Game2048 {
    
    private var board: [[Tile]] = []
    private var emptyCells: [Position] = []
    private var dimension: Int {
        return App.boardDimension
    }
    private var boardChanges: [BoardChange] = []
    
    private var isGameOver: Bool {
        if !emptyCells.isEmpty {
            return false
        }
        return !someTileHasEqualNeighbours()
    }
    
    init() {
        for row in 0..<dimension {
            var boardRow: [Tile] = []
            for column in 0..<dimension {
                boardRow.append(Tile(nil, positionToSet: Position(row: row, column: column)))
                emptyCells.append(boardRow.last!.position)
            }
            board.append(boardRow)
        }
    }
    
    /**
     Moves all tiles in specified direction and merges them if needed
     Adds new random tile if move has occured and checks if game is over or not
     Sends all changes to controller
     
     - Parameter direction: direction to move tiles
     */
    func moveTiles(to direction : Direction) {
        var boardHasChanged = false
        for rowOrColumnIndex in board.indices {
            var rowOrColumnArray = (direction == .up || direction == .down) ?
                getColumn(at: rowOrColumnIndex) : getRow(at: rowOrColumnIndex)
            if direction == .right || direction == .down {
                rowOrColumnArray.reverse()
            }
            boardHasChanged = process(rowOrColumn: rowOrColumnArray) ? true : boardHasChanged
        }
        sendChangesToController()
        if boardHasChanged {
            addNewRandomTile()
        } else {
            boardChanges.append(.wrongMove(direction))
        }
        sendChangesToController()
        checkIfGameOver()
    }
    
    /**
     Checks if board is stored in UserDefaults and loads it in this case, otherwise
     adds specified in AppPreferences number of randow tiles
     If stored board is outdated (dimension has changed in AppPreferences) restarts the game
     Sends all changes to controller
     */
    func startGame() {
        if let boardValuesArray = UserDefaults.standard.array(forKey: "BoardValues") as? [Int], !boardValuesArray.isEmpty {
            if boardValuesArray.count != dimension * dimension {
                restartGame()
            } else {
                loadBoardFrom(array: boardValuesArray)
            }
        } else {
            for _ in 0..<App.numberOfInitialTiles {
                addNewRandomTile()
            }
        }
        sendChangesToController()
    }
    
    /**
     Unloads board stored in UserDefaults, refills game board with empty cells and starts new game
     */
    func restartGame() {
        UserDefaults.standard.set(nil, forKey: "BoardValues")
        emptyCells.removeAll()
        for row in 0..<dimension {
            for column in 0..<dimension {
                board[row][column].removeFromBoard()
                emptyCells.append(Position(row: row, column: column))
            }
        }
        startGame()
    }
    
    private func getRow(at rowIndex: Int) -> [Tile] {
        return board[rowIndex]
    }
    
    private func getColumn(at columnIndex: Int) -> [Tile] {
        var columnArray: [Tile] = []
        for row in board.indices {
            columnArray.append(board[row][columnIndex])
        }
        return columnArray
    }
    
    private func process(rowOrColumn: [Tile]) -> Bool {
        var lastMergedPosition = Position(row: -1, column: -1)
        var boardHasChanged = false
        for currentTileIndex in board.indices {
            if rowOrColumn[currentTileIndex].isOnBoard() {
                var indexToCheck = currentTileIndex - 1
                var needToMoveTile = false
                var tileWasMerged = false
                while indexToCheck >= 0 {
                    let destinationTile = rowOrColumn[indexToCheck]
                    if destinationTile.isOnBoard() && destinationTile == rowOrColumn[currentTileIndex]
                                                   && destinationTile.position != lastMergedPosition {
                        merge(tile: rowOrColumn[currentTileIndex], with: destinationTile)
                        lastMergedPosition = destinationTile.position
                        tileWasMerged = true
                        boardHasChanged = true
                        break
                    } else if !destinationTile.isOnBoard() {
                        indexToCheck -= 1
                        needToMoveTile = true
                    } else {
                        break
                    }
                }
                if (!tileWasMerged && needToMoveTile) {
                    move(tile: rowOrColumn[currentTileIndex], to: rowOrColumn[indexToCheck + 1])
                    boardHasChanged = true
                }
            }
        }
        return boardHasChanged
    }
    
    private func sendChangesToController() {
        if !boardChanges.isEmpty {
            NotificationCenter.default.post(name: .modelDidChange, object: nil, userInfo: ["boardChanges" : boardChanges])
            boardChanges.removeAll()
        }
    }
    
    private func someTileHasEqualNeighbours() -> Bool {
        for row in board.indices {
            for column in board.indices {
                let currentTile = board[row][column]
                if let upper = board[safe: row - 1]?[safe: column], upper == currentTile {
                    return true
                }
                if let lower = board[safe: row + 1]?[safe: column], lower == currentTile {
                    return true
                }
                if let left = board[safe: row]?[safe: column - 1], left == currentTile {
                    return true
                }
                if let right = board[safe: row]?[safe: column + 1], right == currentTile {
                    return true
                }
            }
        }
        return false
    }
    
    private func move(tile sourceTile: Tile, to destinationTile: Tile) {
        emptyCells.remove(at: emptyCells.firstIndex(of: destinationTile.position)!)
        board[destinationTile.position.row][destinationTile.position.column].containedValue = sourceTile.containedValue
        emptyCells.append(sourceTile.position)
        boardChanges.append(.move(sourceTile.copy() as! Tile, destinationTile.position))
        board[sourceTile.position.row][sourceTile.position.column].removeFromBoard()
        saveBoard()
    }
    
    private func merge(tile sourceTile: Tile, with destinationTile: Tile) {
        destinationTile.doubleTheValue()
        boardChanges.append(.merge(sourceTile.copy() as! Tile, destinationTile.copy() as! Tile))
        emptyCells.append(sourceTile.position)
        board[sourceTile.position.row][sourceTile.position.column].removeFromBoard()
        saveBoard()
    }
    
    private func checkIfGameOver() {
        if isGameOver {
            boardChanges.append(.restartByLoss)
            sendChangesToController()
            restartGame()
        }
    }
    
    private func addNewRandomTile() {
        let position = emptyCells[Int.random(in: 0..<emptyCells.count)]
        addTile(at: position, withValue: getRandomValueForTile())
    }
    
    private func getRandomValueForTile() -> Int {
        return Double.random(in: 0.0...1.0) <= App.luckyChanceOfValue4 ? 4 : 2
    }
    
    private func addTile(at position: Position, withValue value: Int, fromSavedData: Bool = false) {
        board[position.row][position.column].containedValue = value
        emptyCells.remove(at: emptyCells.firstIndex(of: position)!)
        if !fromSavedData {
            boardChanges.append(.add(board[position.row][position.column].copy() as! Tile))
        } else {
            boardChanges.append(.load(board[position.row][position.column].copy() as! Tile))
        }
        saveBoard()
    }
    
    private func saveBoard() {
        var boardValuesArray: [Int?] = []
        for row in 0..<dimension {
            for column in 0..<dimension {
                boardValuesArray.append(board[row][column].containedValue ?? -1)
            }
        }
        UserDefaults.standard.set(boardValuesArray, forKey: "BoardValues")
    }
    
    private func loadBoardFrom(array: [Int]) {
        for row in 0..<dimension {
            for column in 0..<dimension {
                if array[row * dimension + column] != -1 {
                    addTile(at: Position(row: row, column: column), withValue: array[row * dimension + column], fromSavedData: true)
                }
            }
        }
    }
}

//MARK: - Possible game moves direction
enum Direction {
    case up
    case down
    case right
    case left
}

//MARK: - Collection extension with safe indices
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//MARK: - Add "modelDidChange" to Notification.Name
extension Notification.Name {
    static let modelDidChange = Notification.Name("modelDidChange")
}
