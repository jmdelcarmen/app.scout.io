//
//  VisitsTableViewCell.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/14/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import UIKit

class VisitsTableViewCell: UITableViewCell {
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var attendDateLabel: UILabel!
    @IBOutlet weak var satisfactionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
