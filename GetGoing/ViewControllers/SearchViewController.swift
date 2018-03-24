//
//  SearchViewController.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-10.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var searchTextView: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var segmentControlSwitch: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var searchParameter: String?
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextView.delegate = self
        activityIndicator.isHidden = true
        self.navigationItem.title = "GetGoing"
    }
    
    deinit {
        LocationService.sharedInstance.stopUpdatingLocation()
    }
    
    //MARK: - Activity Indicator
    
    func showActivityIndicator(){
        searchButton.isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator(){
        searchButton.isEnabled = true
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    //MARK: - Button Actions
    @IBAction func presentFilters(_ sender: UIButton) {
        let filtersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FiltersViewController")
        self.present(filtersViewController, animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowHistory" {
//            let destinationViewController = segue.destination as! SearchResultsViewController
//            let loadedPlaces =
//        }
//    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        searchTextView.resignFirstResponder()
        switch segmentControlSwitch.selectedSegmentIndex {
        case 0:
            showActivityIndicator()
            GooglePlacesAPI.requestPlaces(for: searchTextView.text!, param: <#String?#>, radius: <#Int#>, completion: { (status, message, json) in
                print(json ?? "")
                if status == 200, let jsonResponse = json {
                    let placesOfInterest = GooglePlacesAPIParser.parseNearbySearchResults(jsonResponse)
                    self.presentSearchResults(placesOfInterest)
                } else {
                    self.presentErrorMessage(statusCode: status, errorDescription: NSLocalizedString("error.description", comment: ""))
                }
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
            })
        case 1:
            if let coordinate = self.currentLocation?.coordinate {
                showActivityIndicator()
                GooglePlacesAPI.requestPlaces(for: coordinate, param: searchParameter, radius: 6500, completion: { (status, message, json) in
                    print(json ?? "")
                    if status == 200, let jsonResponse = json {
                        let placesOfInterest = GooglePlacesAPIParser.parseNearbySearchResults(jsonResponse)
                        self.presentSearchResults(placesOfInterest)
                    } else {
                        self.presentErrorMessage(statusCode: status, errorDescription: NSLocalizedString("error.description", comment: ""))
                    }
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                })
            } else {
                self.presentErrorMessage(errorDescription: NSLocalizedString("error.description", comment: ""))
            }
        default:
            break;
        }
        
        
    }
    
    @IBAction func searchTypeSegmentControlSwitch(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            LocationService.sharedInstance.delegate = self
            LocationService.sharedInstance.startUpdatingLocation()
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined:
                    break;
                case .restricted, .denied:
                    segmentControlSwitch.setEnabled(false, forSegmentAt: 1)
                case .authorizedAlways, .authorizedWhenInUse:
                    segmentControlSwitch.setEnabled(true, forSegmentAt: 0)
                }
            }
        }
    }
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowHistory" {
            let destinationViewController = segue.destination as! SearchResultsViewController
            let loadedPlaces = loadListsFromLocalStorage() ?? []
            destinationViewController.placesOfInterest = loadedPlaces
        }
    }
    
    func presentSearchResults(_ placesOfInterest: [PlaceOfInterest]){
        let searchResultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        searchResultsViewController.placesOfInterest = placesOfInterest
        savePlacesToLocalStorage(places: placesOfInterest)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(searchResultsViewController, animated: true)
        }
    }
    
    //MARK: - TextField Delegate methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTextView {
            print(searchTextView.text ?? "none")
            self.searchParameter = searchTextView.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextView {
            searchTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //MARK: - Error Handling
    func presentErrorMessage(statusCode: Int = 500, errorDescription: String?){
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: NSLocalizedString("error.title", comment: ""), message: errorDescription, preferredStyle: .alert)
            
            let style: UIAlertActionStyle = statusCode == 200 ? .default : .cancel
            let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: style, handler: nil)
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Local Storage
    
    func savePlacesToLocalStorage(places: [PlaceOfInterest]) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(places, toFile: PlaceOfInterest.ArchiveURL.path)
        
        if !isSuccessfulSave {
            print("Failed to save places..")
        }
    }
    
    func loadListsFromLocalStorage() -> [PlaceOfInterest]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: PlaceOfInterest.ArchiveURL.path) as? [PlaceOfInterest]
    }
    
}


extension SearchViewController: LocationServiceDelegate {
    
    // MARK: LocationService Delegate
    
    func tracingLocation(_currentLocation currentLocation: CLLocation) {
        self.currentLocation = currentLocation
    }
    
    func tracingLocationDidFailWithError(_error error: Error) {
        print("tracing Location Error : \(error.localizedDescription)")
    }
}
