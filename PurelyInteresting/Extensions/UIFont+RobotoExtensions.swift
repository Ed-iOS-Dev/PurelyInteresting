//
//  UIFont+RobotoExtensions.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 04/03/26.
//

import UIKit

// MARK: - UIFont+Roboto

extension UIFont {
    
    enum RobotoStyle: String {
        case regular = "Roboto-Regular"
        case medium  = "Roboto-Medium"
    }
    
    static func roboto(_ style: RobotoStyle, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: style.rawValue, size: size) else {
            return .systemFont(ofSize: size)
        }
        return font
    }
}
