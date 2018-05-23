//
//  HomeViewController.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/10/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import UIKit
import SkeletonView
import PopupDialog
import CoreLocation
import RealmSwift

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    var recommendationData: Results<Recommendation>? // Collection data
    var discoverData: Results<Discover>? // Table data
    
    var currentCoords: CLLocationCoordinate2D? {
        didSet {
            self.loadRecommendations()
            self.loadPlacesToDiscover()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 80.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        let coords = location.coordinate

        self.locationManager.stopUpdatingLocation()
        
        self.currentCoords = coords
    }

    func loadRecommendations() -> Void {
        ScoutRequest().getRecommendations(withPage: 1) { (error, response) in
            if error == nil {
                self.recommendationData = response!
                self.collectionView.reloadData()
            } else {
                print(error!)
            }
        }
    }
    
    func loadPlacesToDiscover() -> Void {
        let coords: Dictionary<String, Double> = [
            "latitude": self.currentCoords!.latitude,
            "longitude": self.currentCoords!.longitude
        ]

        ScoutRequest().getPlacesToDiscover(withCoords: coords) { (error, response) in
            if error == nil {
                self.discoverData = response!
                self.tableView.reloadData()
            } else {
                print(error!)
            }
        }
    }
    
    func showCellPressedPopup(selectedCellData: Object, pressedCell: Any) -> Void {
        let popup = PopupDialog(title: selectedCellData["name"] as? String, message: nil)
        let addToVisitsButton = DefaultButton(title: "Add to visits", height: 60, dismissOnTap: true) {
            self.performSegue(withIdentifier: "addToVisits", sender: pressedCell)
        }
        let viewOnYelpButton = DefaultButton(title: "View on Yelp!", height: 60, dismissOnTap: true) {
            self.performSegue(withIdentifier: "viewOnYelp", sender: pressedCell)
        }
        
        popup.addButtons([addToVisitsButton, viewOnYelpButton])
        
        self.present(popup, animated: true, completion: nil)
    }
}

// MARK: - Collection view protocol methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recommendationData?.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell

        cell.viewContainer.isSkeletonable = true
        cell.viewContainer.layer.masksToBounds = true
        cell.viewContainer.layer.cornerRadius = 14
        
        cell.imageView.isSkeletonable = true
        cell.imageView.layer.masksToBounds = true
        cell.imageView.layer.cornerRadius = 14

        if let recommendation = self.recommendationData?[indexPath.row] {
            cell.imageView.imageFromServerURL(urlString: recommendation.imageUrl)
            
            cell.viewContainer.hideSkeleton()
            cell.labelView.text = recommendation.name
            cell.priceLabelView.text = recommendation.price
        } else {
            cell.viewContainer.showAnimatedGradientSkeleton()
        }

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        if let recommendation = self.recommendationData?[indexPath.row] {
            self.showCellPressedPopup(selectedCellData: recommendation, pressedCell: cell)
        }
    }
}

// MARK: - Places TableView delegate methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discoverData?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        let cellComponents = [cell.placeImageView,
                              cell.placeTitleLabel,
                              cell.placeLocationLabel,
                              cell.placeOpenStatusLabel,
                              cell.placePriceLabel,
                              cell.placeCategoriesLabel]
        
        if let discovery = self.discoverData?[indexPath.row] {
            for cellComponent in cellComponents {
                cellComponent?.hideSkeleton()
            }

            cell.placeImageView.imageFromServerURL(urlString: discovery.imageUrl)
            cell.placeTitleLabel.text = discovery.name
            cell.placeLocationLabel.text = discovery.location
            cell.placeOpenStatusLabel.text = discovery.isClosed ? "Closed" : "Open"
            cell.placeOpenStatusLabel.textColor = discovery.isClosed ? #colorLiteral(red: 0.9215686275, green: 0.231372549, blue: 0.3529411765, alpha: 1) : #colorLiteral(red: 0.1490196078, green: 0.8705882353, blue: 0.5058823529, alpha: 1)
            cell.placePriceLabel.text = discovery.price    
        } else {
            for cellComponent in cellComponents {
                cellComponent?.showAnimatedGradientSkeleton()
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! HomeTableViewCell
        if let item = self.discoverData?[indexPath.row] {
            self.showCellPressedPopup(selectedCellData: item, pressedCell: cell)
        }
    }
}

// MARK: - YelpWebView handler
extension HomeViewController: YelpWebViewControllerDelegate, AddToVisitsViewControllerDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "viewOnYelp":
            let destinationVC = segue.destination as! YelpWebViewController
            let cellIndexPath = self.collectionView.indexPath(for: sender as! UICollectionViewCell)!
            let yelpId = self.recommendationData?[cellIndexPath.row].yelpId

            destinationVC.delegate = self
            destinationVC.yelpId = yelpId
        case "addToVisits":
            let senderIsTypeHomeTableViewCell = type(of: sender!) == type(of: HomeTableViewCell())
            let senderIsTypeImageCollectionViewCell = type(of: sender!) == type(of: ImageCollectionViewCell())
            var cellIndexPath = IndexPath()
            var yelpId = String()
            
            if senderIsTypeHomeTableViewCell {
                cellIndexPath = self.tableView.indexPath(for: sender as! UITableViewCell)!
                yelpId = self.discoverData![cellIndexPath.row].yelpId
                
            } else if senderIsTypeImageCollectionViewCell {
                cellIndexPath = self.collectionView.indexPath(for: sender as! UICollectionViewCell)!
                yelpId = self.recommendationData![cellIndexPath.row].yelpId
            } else {
                print("Unidentified sender for addToVisits segue")
            }

            let destinationVC = segue.destination as! AddToVisitsViewController
            destinationVC.delegate = self
            destinationVC.yelpId = yelpId
        default: break
        }
    }
    
    func onAddedToVisitsSuccess() -> Void {
        self.recommendationData = nil
        self.collectionView.reloadData()
        self.loadRecommendations()
    }
}

// MARK: - Async image loading
// TODO: replace with library that uses caching
extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }
}

