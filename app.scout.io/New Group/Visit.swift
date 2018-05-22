//
//  Visit.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/21/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import Foundation
import RealmSwift

class Visit: Object {
    @objc dynamic var refetchedAt: NSDate = NSDate()
    @objc dynamic var attendDate: NSDate = NSDate()
    @objc dynamic var yelpId: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var satisfaction: Int = 0
}
