//
//  UserDefaultsConfig.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/23/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import Foundation


class UserDefaultsConfig {
    let defaults: UserDefaults

    init() {
        self.defaults = UserDefaults.standard
    }
    
    func start() -> Void {
        if self.defaults.object(forKey: "refetchMetadata") == nil {
            let dict = [
                "recommendations": ["shouldRefetch": true, "refetchedAt": NSDate()],
                "discoveries": ["shouldRefetch": true, "refetchedAt": NSDate()],
                "visits": ["shouldRefetch": true, "refetchedAt": NSDate()],
                ]
            
            self.defaults.set(dict, forKey: "refetchMetadata")
        }
    }
}
