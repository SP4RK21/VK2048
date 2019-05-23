//
//  Tile.swift
//  VK2048
//
//  Created by SP4RK on 09/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//
import Foundation

class Tile: NSCopying {
    
    var position: Position
    var containedValue: Int?
    
    init(_ valueToSet: Int?, positionToSet: Position = Position(row: 0, column: 0)) {
        containedValue = valueToSet
        position = positionToSet
    }
    
    static func ==(lhs: Tile, rhs: Tile) -> Bool {
        return lhs.containedValue == rhs.containedValue
    }
    
    /**
     Removes tile from board
     */
    func removeFromBoard() {
        containedValue = nil
    }
    
    /**
     Checks if tile is on board
     
     - Returns: true if tile is on board, false otherwise
     */
    func isOnBoard() -> Bool {
        return containedValue != nil
    }
    
    /**
     Doubles the value contained in tile
     */
    func doubleTheValue() {
        containedValue! *= 2
    }
    
    /**
     Makes a copy of tile
     
     - Returns: copy of tile as Any type
     */
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Tile(containedValue, positionToSet: position)
        return copy
    }
}
