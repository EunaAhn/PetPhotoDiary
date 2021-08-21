//
//  SceneDelegate.swift
//  PetPhotoDiary
//
//  Created by Euna Ahn on 2021/05/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {

    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
 
    }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {

    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {

        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

