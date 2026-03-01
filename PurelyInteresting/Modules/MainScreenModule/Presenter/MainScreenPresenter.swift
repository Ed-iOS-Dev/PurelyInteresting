//
//  MainScreenPresenter.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - MainScreenPresenterProtocol

protocol MainScreenPresenterProtocol: AnyObject {}

// MARK: - MainScreenPresenter

final class MainScreenPresenter: MainScreenPresenterProtocol {
    
    weak var view: MainScreenViewProtocol?
    
    init(view: MainScreenViewProtocol) {
        self.view = view
    }
}
