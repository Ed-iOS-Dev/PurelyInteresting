//
//  prepareForAutoLayout.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 28.02.26.
//

import UIKit

/// Отключает translatesAutoresizingMaskIntoConstraints и возвращает view.
public func prepareForAutoLayout<T: UIView>(_ view: T) -> T {
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
}
