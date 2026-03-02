//
//  View+Extensions.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 28.02.26.
//

import UIKit

public extension UIView {
    
    /// Добавляет массив subview к текущему view
    /// /// Если needToPrepare == true, отключает translatesAutoresizingMaskIntoConstraints у каждого
    func addSubviews(_ views: [UIView], prepareForAutoLayout needToPrepare: Bool = true) {
        views.forEach{ addSubview(needToPrepare ? prepareForAutoLayout ($0) : $0) }
    }
}
