//
//  CGPointExtension.swift
//  VK2048
//
//  Created by SP4RK on 19/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

extension CGPoint {
    static func +(first: CGPoint, second: CGPoint) -> CGPoint {
        return CGPoint(x: first.x + second.x, y: first.y + second.y)
    }
    static func -(first: CGPoint, second: CGPoint) -> CGPoint {
        return CGPoint(x: first.x - second.x, y: first.y - second.y)
    }
}

