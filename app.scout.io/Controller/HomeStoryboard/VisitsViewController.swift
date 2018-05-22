//
//  VisitsViewController.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/10/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import UIKit

class VisitsViewController: AuthenticatedViewController {
    @IBOutlet weak var tableView: UITableView!

    // TODO: group by month
    var visitsHistory: [Dictionary<String, Any>]?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadVisitsHistory(page: 1)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 80
        self.tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadVisitsHistory(page: Int) -> Void {
        ScoutRequest().getVisits(withPage: page) { (error, response) in
            if error == nil {
                self.visitsHistory = (response!["data"].arrayObject as! [Dictionary<String, Any>])
                self.tableView.reloadData()
            } else {
                print(error)
            }
        }
    }
}

extension VisitsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitsTableViewCell", for: indexPath) as! VisitsTableViewCell

        if let item = self.visitsHistory?[indexPath.row] {
            cell.placeLabel.hideSkeleton()
            cell.attendDateLabel.hideSkeleton()
            
            cell.placeLabel.text = (item["data"] as AnyObject)["name"] as? String
            cell.attendDateLabel.text = item["attend_date"] as? String
        } else {
            cell.placeLabel.showSkeleton()
            cell.attendDateLabel.showSkeleton()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.visitsHistory?.count ?? 10
    }
}









