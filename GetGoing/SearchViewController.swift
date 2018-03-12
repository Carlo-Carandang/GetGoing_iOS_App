//
//  SearchViewController.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-10.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var searchTextView: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var segmentControlSwitch: UISegmentedControl!
    
    var searchParameter: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    
    @IBAction func performAPICall(_ sender: UIButton) {
        searchTextView.resignFirstResponder()
        if segmentControlSwitch.selectedSegmentIndex == 0 {
            GooglePlacesAPI.requestPlaces(query: searchParameter, completion: { (status, errorMessage, json) in print(json)
//                print(errorMessage)
//                print(status)
                
                if status == 200, let jsonResponse = json {
                    let placesOfInterest = GooglePlacesAPIParser.parseNearbySearchResults(jsonResponse)
                    self.presentSearchResults(places: placesOfInterest)
                }
                else {
                    
                }
            })
        }
    }
    
    func presentSearchResults(places:[PlaceOfInterest]){
        
        let searchResultsViewController =
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        searchResultsViewController.places = places
        
        self.navigationController?.pushViewController(searchResultsViewController, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchTextView {
            if let searchParam = textField.text {
                searchParameter = searchParam
            }
            //            searchParameter = textField.text ?? ""
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextView {
            searchTextView.resignFirstResponder()
            return true
        }
        return false
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
