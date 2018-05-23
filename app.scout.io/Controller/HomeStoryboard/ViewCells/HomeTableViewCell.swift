//
//  HomeTableViewCell.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/14/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeTitleLabel: UILabel!
    @IBOutlet weak var placeLocationLabel: UILabel!
    @IBOutlet weak var placeOpenStatusLabel: UILabel!
    @IBOutlet weak var placePriceLabel: UILabel!
    @IBOutlet weak var placeCategoriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
