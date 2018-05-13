//
//  AddToVisitsViewController.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/12/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol AddToVisitsViewControllerDelegate {
    func onAddedToVisitsSuccess() -> Void
}

class AddToVisitsViewController: UIViewController {
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var sadSmiley: UIImageView!
    @IBOutlet weak var neutralSmiley: UIImageView!
    @IBOutlet weak var happySmiley: UIImageView!
    
    var delegate: AddToVisitsViewControllerDelegate?
    var yelpId: String?
    var satisfaction: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onSelectSmiley(tag: Int) -> Void {
        let smileys: [UIImageView] = [sadSmiley, neutralSmiley, happySmiley]
        for smiley in smileys {
            smiley.alpha = 0.5
        }
        
        smileys[tag - 1].alpha = 1
        self.satisfaction = tag
    }
    
    func getFormattedDateFromPicker() -> String {
        let date = self.datePickerView.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd YYYY hh:mm a"

        return dateFormatter.string(from: date)
    }
    
    @IBAction func onAddToVisitsPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        ScoutRequest().createVisit(withYelpId: self.yelpId!,
                                   attendDate: self.getFormattedDateFromPicker(),
                                   satisfaction: self.satisfaction!) { (error, response) in
            if error == nil {
                SVProgressHUD.dismiss()
                self.delegate?.onAddedToVisitsSuccess()
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                SVProgressHUD.showError(withStatus: "Request failed")
            }
        }
    }

    @IBAction func onSadSmileyPressed(_ sender: UIButton) {
        self.onSelectSmiley(tag: sender.tag)
    }

    @IBAction func onNeutralSmileyPressed(_ sender: UIButton) {
        self.onSelectSmiley(tag: sender.tag)
    }

    @IBAction func onHappySmileyPressed(_ sender: UIButton) {
        self.onSelectSmiley(tag: sender.tag)
    }
}
