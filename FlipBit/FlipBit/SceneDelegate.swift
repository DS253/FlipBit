//
//  SceneDelegate.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = BybitTradeViewController()
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("SceneDidDisconnect")
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("SceneDidBecomeActive")
        bookObserver.connectToSocket()
        symbolObserver.connectToSocket()
        tradeObserver.connectToSocket()
//        positionObserver.connectToSocket()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("SceneWillResignActive")
        bookObserver.disconnectFromSocket()
        symbolObserver.disconnectFromSocket()
        tradeObserver.disconnectFromSocket()
//        positionObserver.disconnectFromSocket()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("SceneWillEnterForeground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("SceneDidEnterBackground")
    }
}
