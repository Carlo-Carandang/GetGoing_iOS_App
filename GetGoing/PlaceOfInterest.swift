//
//  PlaceOfInterest.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-10.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import Foundation
import CoreLocation

class PlaceOfInterest: NSObject {
    var id: String
    var name: String?
    var rating: Double?
    var icon: URL?
    var photoReference: String?
    var maxWidth: Int?
    var types: [String]
    var vicinity: String?
    var formattedAddress: String?
    var categories: String?
    var location: CLLocation?
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String else {
            return nil
        }
        
        guard let name = json["name"] as? String else {
            return nil
        }
        self.rating = json["rating"] as? Double
        
        if let geometry = json["geometry"] as? [String: Any] {
            if let location = geometry["location"] as? [String: Any] {
                if let lat = location["lat"] as? Double,
                    let lng = location["lng"] as? Double {
                    self.location = CLLocation(latitude: lat, longitude: lng)
                }
            }
        }
        
        self.types = json["types"] as? [String] ?? []
        self.id = id
        self.name = name
    }
}
