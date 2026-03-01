//
//  MainScreenCoordinator.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - MainScreenCoordinator

final class MainScreenCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    let builder: AppBuilder
    var rootController: UINavigationController?
    
    var onFinishFlow: (() -> Void)?
    
    // MARK: - Initializers
    
    init(builder: AppBuilder) {
        self.builder = builder
    }
    
    // MARK: - Public Methods
    
    func setViewController(controller: UIViewController) {
        rootController = UINavigationController(rootViewController: controller)
    }
    
    func moveToChatScreen(chatUser: ChatUser) {
        let chatVC = builder.makeChatModule(
            coordinator: self,
            chatUser: chatUser
        )
        rootController?.pushViewController(chatVC, animated: true)
    }
    
    func returnToRoot() {
        rootController?.popViewController(animated: true)
    }
}
