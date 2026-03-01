//
//  ChatPresenter.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - ChatPresenterProtocol

protocol ChatPresenterProtocol: AnyObject {}

// MARK: - ChatPresenter

final class ChatPresenter: ChatPresenterProtocol {
    
    weak var view: ChatViewProtocol?
    
    init(view: ChatViewProtocol) {
        self.view = view
    }
}
