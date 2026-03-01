//
//  AppBuilder.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - AppBuilder

final class AppBuilder {
    
    // MARK: - Constants
    
    enum Constants {
        static let messagesTabBarTitle = "Сообщения"
        static let feedTabBarTitle = "Лента"
        static let savedTabBarTitle = "Избранное"
        static let profileTabBarTitle = "Профиль"
    }
    
    // MARK: - Authorization Module
    
    func makeAuthorizationModule(
        coordinator: AuthCoordinator
    ) -> AuthorizationViewController {
        let view = AuthorizationViewController()
        let presenter = AuthorizationPresenter(
            view: view,
            coordinator: coordinator
        )
        view.presenter = presenter
        
        return view
    }
    
    // MARK: - MainScreen Module
    
    func makeMainScreenModule(
        coordinator: MainScreenCoordinator
    ) -> MainScreenViewController {
        let view = MainScreenViewController()
        let presenter = MainScreenPresenter(
            view: view,
            coordinator: coordinator
        )
        view.presenter = presenter
        view.tabBarItem = UITabBarItem(
            title: Constants.messagesTabBarTitle,
            image: UIImage(systemName: "bubble.left.and.bubble.right"),
            selectedImage: UIImage(systemName: "bubble.left.and.bubble.right.fill")
        )
        
        return view
    }
    
    // MARK: - Chat Module
    
    func makeChatModule(
        coordinator: MainScreenCoordinator,
        chatUser: ChatUser
    ) -> ChatViewController {
        let view = ChatViewController(chatUser: chatUser)
        let presenter = ChatPresenter(
            view: view,
            coordinator: coordinator
        )
        view.presenter = presenter
        
        return view
    }
    
    // MARK: - Placeholder Modules
    
    func makeFeedModule() -> UIViewController {
        let view = PlaceholderViewController(title: Constants.feedTabBarTitle)
        view.tabBarItem = UITabBarItem(
            title: Constants.feedTabBarTitle,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        return view
    }
    
    func makeSavedModule() -> UIViewController {
        let view = PlaceholderViewController(title: Constants.savedTabBarTitle)
        view.tabBarItem = UITabBarItem(
            title: Constants.savedTabBarTitle,
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        return view
    }
    
    func makeProfileModule() -> UIViewController {
        let view = PlaceholderViewController(title: Constants.profileTabBarTitle)
        view.tabBarItem = UITabBarItem(
            title: Constants.profileTabBarTitle,
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )
        
        return view
    }
}
