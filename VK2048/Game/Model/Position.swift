//
//  Position.swift
//  VK2048
//
//  Created by SP4RK on 09/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

struct Position : Hashable {
    
    var row: Int, column: Int
    
    static func ==(lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
}
