//
//  Constants.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-10.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import Foundation

class Constants {
    
    static let apiKey = "AIzaSyAwczeG1wrDWTlvlDxxrZeY9qWfugzasXI"
    static let scheme = "https"
    static let host = "maps.googleapis.com"
    static let textPlaceSearch = "/maps/api/place/textsearch/json"
    static let coordinatePlaceSearch = "/maps/api/place/nearbysearch/json"
    static let placeDetails = "/maps/api/place/details/json"
    static let placePhotoSearch = "/maps/api/place/photo"
    static let radius = 5000
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("PlacesOfInterest")
}
