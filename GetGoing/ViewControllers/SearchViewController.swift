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
    
    var SearchParameter: String = ""
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextView.delegate = self
        activityIndicator.isHidden = true
     //   self.navigationItem.title = "GetGoing"
    }
    
    //MARK: - Button Actions
    @IBAction func presentFilters(_ sender: UIButton) {
        let filtersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FiltersViewController")
        self.present(filtersViewController, animated: true, completion: nil)
    }
    //Mark: - IBActions
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            LocationService.sharedInstance.startUpdatingLocation()
            LocationService.sharedInstance.delegate = self
        }
    }
    
    @IBAction func performapicall(_ sender: UIButton) {
        //print(SearchParameter)
        searchTextView.resignFirstResponder()
        
        if segmentControlSwitch.selectedSegmentIndex == 0 {
            startSpinner()
            GooglePlacesAPI.requestPlaces(query: SearchParameter, completion: { (status, errorMessage, json) in
                //print(json ?? "")
                if status == 200, let jsonResponse = json {
                    let placesOfInterest = GooglePlacesAPIParser.parseNearbySearchResults(jsonResponse)
                    self.presentSearchResults(placesOfInterest)
                }
                self.stopSpinner()
                
            })
        } else {
            if let coordinate = currentLocation?.coordinate {
                GooglePlacesAPI.requestPlaces(coordinate: coordinate, keyword: SearchParameter, completion: {(status, errorMessage, json) in
                    if status == 200, let jsonResponse = json {
                        let placesOfInterest = GooglePlacesAPIParser.parseNearbySearchResults(jsonResponse)
                        self.presentSearchResults(placesOfInterest)
                    }
                })
            }
        }
    }

    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowHistory" {
            let destinationViewController = segue.destination as! SearchResultsViewController
            let loadedPlaces = loadListsFromLocalStorage() ?? []
            destinationViewController.places = loadedPlaces
        }
    }
    
    func presentSearchResults(_ places: [PlaceOfInterest]){
        let SearchResultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        SearchResultsViewController.places = places
        if places.count > 0 {
            savePlacesToLocalStorage(places: places)
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(SearchResultsViewController, animated: true)
        }
    }
    //activity indicator
    func startSpinner(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        self.searchButton.isEnabled = false
    }
    func stopSpinner(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.searchButton.isEnabled = true
        }
    }
    //MARK: - TextField Delegate methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTextView {
            if let searchParam = textField.text {
                SearchParameter = searchParam
            }
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
    func tracingLocation(_currentLocation currentLocation: CLLocation) {
        self.currentLocation = currentLocation
    }
    
    func tracingLocationDidFailWithError(_error error: Error) {
        print(error.localizedDescription)
    }
}
