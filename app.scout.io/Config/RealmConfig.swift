//
//  RealmConfig.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/23/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig {
    init() {
        Realm.Configuration.defaultConfiguration = self.getMigrateConfig()
    }

    func start() -> Void {
        do {
            _ = try Realm()
        } catch let e {
            print(e)
            print("Error initializing Realm")
        }
    }

    func getMigrateConfig() -> Realm.Configuration {
    
        let currentSchemaVersion = 1
        
        let config = Realm.Configuration(fileURL: Realm.Configuration.defaultConfiguration.fileURL,
                                         inMemoryIdentifier: nil,
                                         syncConfiguration: nil,
                                         encryptionKey: nil,
                                         readOnly: false,
                                         schemaVersion: UInt64(currentSchemaVersion),
                                         migrationBlock: { migration, oldSchemaVersion in
                                            if oldSchemaVersion < currentSchemaVersion {
                                                migration.enumerateObjects(ofType: Discover.className()) { (oldDiscovery, newDiscovery) in
                                                    newDiscovery!["categories"] = ""
                                                }
                                            }
                                        }, deleteRealmIfMigrationNeeded: true)
        
        return config
    }
}

