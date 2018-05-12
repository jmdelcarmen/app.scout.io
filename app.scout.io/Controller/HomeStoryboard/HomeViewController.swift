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

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var data: [Dictionary<String, Any>]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadRecommendations()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadRecommendations() -> Void {
        ScoutRequest().getRecommendations(withPage: 1) { (error, response) in
            if error == nil {
                self.data = (response!["data"].arrayObject as! [Dictionary<String, Any>])
                self.collectionView.reloadData()
            } else {
                print(error!)
            }
        }
    }
}

// MARK: - Collection view protocol methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell

        cell.imageView.isSkeletonable = true
        cell.imageView.layer.shadowOpacity = 0.2
        cell.imageView.layer.shadowOffset = CGSize(width: 1, height: 1)

        cell.viewContainer.isSkeletonable = true
        cell.viewContainer.layer.shadowOpacity = 0.2
        cell.viewContainer.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        
        if let item = self.data?[indexPath.row] {
            cell.imageView.hideSkeleton()
            cell.imageView.imageFromServerURL(urlString: item["image_url"] as! String)
            
            cell.viewContainer.hideSkeleton()
            cell.labelView.text = item["name"] as? String
            cell.priceLabelView.text = item["price"] as? String
        } else {
            cell.imageView.showAnimatedGradientSkeleton()
            cell.viewContainer.showAnimatedGradientSkeleton()
        }

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        if let item = self.data?[indexPath.row] {
            self.showCellPressedPopup(selectedCellData: item, pressedCell: cell)
        }
    }

    func showCellPressedPopup(selectedCellData: Dictionary<String, Any>, pressedCell: ImageCollectionViewCell) -> Void {
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

extension HomeViewController: YelpWebViewControllerDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "viewOnYelp":
            let destinationVC = segue.destination as! YelpWebViewController
            let cellIndexPath = self.collectionView.indexPath(for: sender as! UICollectionViewCell)!
            let yelpId = self.data?[cellIndexPath.row]["id"] as! String

            destinationVC.delegate = self
            destinationVC.yelpId = yelpId
        case "addToVisits":
            break
        default: break
        }
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

