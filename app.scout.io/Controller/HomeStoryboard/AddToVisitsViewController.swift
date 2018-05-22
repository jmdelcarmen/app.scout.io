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

class AddToVisitsViewController: AuthenticatedViewController {
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var maybeButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var delegate: AddToVisitsViewControllerDelegate?
    var yelpId: String?
    var satisfaction: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onWillReturnButtonOptionPressed(tag: Int) -> Void {
        let willReturnOptionButtons: [UIButton] = [noButton, maybeButton, yesButton]
        for optionButton in willReturnOptionButtons {
            optionButton.alpha = 0.5
        }
        
        willReturnOptionButtons[tag - 1].alpha = 1
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
    
    @IBAction func onNoPressed(_ sender: UIButton) {
        self.onWillReturnButtonOptionPressed(tag: sender.tag)
    }
    @IBAction func onMaybePressed(_ sender: UIButton) {
        self.onWillReturnButtonOptionPressed(tag: sender.tag)
    }
    @IBAction func onYesPressed(_ sender: UIButton) {
        self.onWillReturnButtonOptionPressed(tag: sender.tag)
    }
    
}
