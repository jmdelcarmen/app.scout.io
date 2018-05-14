//
//  PlacesViewController.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/13/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import UIKit

class PlacesViewController: AuthenticatedViewController {

    @IBOutlet weak var searchbar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchbar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PlacesViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchbar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchbar.setShowsCancelButton(false, animated: true)
        self.searchbar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchbar.setShowsCancelButton(false, animated: true)
        self.searchbar.resignFirstResponder()
    }
}
