//
//  SceneDelegate.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 28.02.26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let viewController = MainScreenViewController()
        let presenter = MainScreenPresenter(view: viewController)
        viewController.presenter = presenter
        
        let navigationController = UINavigationController(
            rootViewController: viewController
        )
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}

