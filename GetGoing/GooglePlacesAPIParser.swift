//
//  GooglePlacesAPIParser.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-10.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import Foundation

class GooglePlacesAPIParser {
    
    class func parseNearbySearchResults(_ json: [String: Any]) -> [PlaceOfInterest] {
        var placesOfInterest: [PlaceOfInterest] = []
        if let results = json["results"] as? [[String: Any]] {
            for result in results {
                if let newPlace = PlaceOfInterest.init(json: result) {
                placesOfInterest.append(newPlace)
                }
            }
        }
        return placesOfInterest
    }
}
