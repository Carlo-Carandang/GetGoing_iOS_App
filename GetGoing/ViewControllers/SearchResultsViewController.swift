//
//  SearchResultsViewController.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-10.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var places: [PlaceOfInterest]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search Results"
        let nib = UINib(nibName: "PlaceTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cellReuseIdentifier")
        
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! PlaceTableViewCell
        cell.placeName.text = places![indexPath.row].name
        if let url = places[indexPath.row].icon, let data = try? Data(contentsOf: url),
            let img = UIImage(data: data) {
            let aspectRatio = img.size.height / img.size.width
            cell.updateAspectRatioConstraint(aspectRatio)
            cell.iconImageView.image = img
            // cell.iconImageView.image = UIImage(data: data)
        }
        if let rating = places[indexPath.row].rating{
            cell.ratingControlView.rating = Int(rating.rounded(.down))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            detailsViewController.place = places[indexPath.row]
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
