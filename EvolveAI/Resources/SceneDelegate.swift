//
//  SceneDelegate.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        UIBarButtonItem.appearance().tintColor = EAColor.action.uiColor
        let goalsService = EAGoalsService()
        let goalsListController = EAGoalsListViewController(goalsService: goalsService)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(goalsListController, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
