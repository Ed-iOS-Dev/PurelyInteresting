//
//  SceneDelegate.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 28.02.26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        window.makeKeyAndVisible()
        self.window = window
        
        appCoordinator = AppCoordinator()
        appCoordinator?.start()
    }
}
