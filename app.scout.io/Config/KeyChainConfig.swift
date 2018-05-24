//
//  KeyChainConfig.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/23/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import Foundation
import KeychainAccess

class KeyChainConfig {
    let window: UIWindow
    let keychain: Keychain

    init(uiWindow: UIWindow) {
        self.keychain = Keychain(service: Bundle.main.bundleIdentifier!)
        self.window = uiWindow
    }
    
    func start() -> Void {
        do {
            let token = try keychain.get("token")
            if token != nil {
                let homeStoryboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
                let homeVC = homeStoryboard.instantiateInitialViewController()
                
                self.window.rootViewController = homeVC
            }
        } catch let e {
            print(e)
            print("Error setting keychain config")
        }
    }
}
