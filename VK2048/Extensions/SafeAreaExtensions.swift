//
//  SafeAreaExtensions.swift
//  VK2048
//
//  Created by SP4RK on 19/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

// MARK: - UILayoutGuide anchoring
extension UILayoutGuide {
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?) {
        if let top = top {
            topAnchor.constraint(equalTo: top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom).isActive = true
        }
    }
}

// MARK: - UIView anchoring
extension UIView {
    var safeScreenHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.layoutFrame.size.height
        }
        return UIScreen.main.bounds.height
    }
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    var safeCenterXAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerXAnchor
        }
        return self.centerXAnchor
    }
    var safeCenterYAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerYAnchor
        }
        return self.centerYAnchor
    }
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?,
                leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing).isActive = true
        }
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?,
                centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil,
                size: CGSize = .zero, padding: UIEdgeInsets = .zero,
                leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}
