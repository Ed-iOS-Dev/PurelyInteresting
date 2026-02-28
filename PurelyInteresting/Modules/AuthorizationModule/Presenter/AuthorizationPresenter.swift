//
//  AuthorizationPresenter.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 28.02.26.
//

import Foundation

// MARK: - AuthorizationPresenterProtocol

protocol AuthorizationPresenterProtocol: AnyObject {}

// MARK: - AuthorizationPresenter

final class AuthorizationPresenter: AuthorizationPresenterProtocol {
    
    weak var view: AuthorizationViewProtocol?
    
    init(view: AuthorizationViewProtocol) {
        self.view = view
    }
}
