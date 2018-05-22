//
//  Recommendation.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/21/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import Foundation
import RealmSwift

class Recommendation: Object {
    // Refetch on if next day
    @objc dynamic var refetchedAt: NSDate = NSDate()
    @objc dynamic var yelpId: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var isClosed: Bool = true
    @objc dynamic var location: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var url: String = ""
}
