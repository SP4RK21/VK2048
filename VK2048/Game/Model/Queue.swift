//
//  Queue.swift
//  VK2048
//
//  Created by SP4RK on 20/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

public struct Queue<T> {
    
    private var array: [T] = []
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    var count: Int {
        return array.count
    }
    
    mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    mutating func clear() {
        array.removeAll()
    }
    
    mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    var front: T? {
        return array.first
    }
}
