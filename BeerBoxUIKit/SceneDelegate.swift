//
//  SceneDelegate.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 28/02/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = UINavigationController(rootViewController: MainViewController())
        removeOpacityBackground(viewController)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
    }

    func sceneDidDisconnect(_: UIScene) {}

    func sceneDidBecomeActive(_: UIScene) {}

    func sceneWillResignActive(_: UIScene) {}

    func sceneWillEnterForeground(_: UIScene) {}

    func sceneDidEnterBackground(_: UIScene) {}

    func removeOpacityBackground(_ viewController: UINavigationController) {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Palette.backgroundColor
            viewController.navigationBar.standardAppearance = appearance
            viewController.navigationBar.scrollEdgeAppearance = viewController.navigationBar.standardAppearance
        }
    }
}
