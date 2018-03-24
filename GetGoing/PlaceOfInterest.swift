//
//  PlaceOfInterest.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-10.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import Foundation
import CoreLocation

class PlaceOfInterest: NSObject, NSCoding {
    
    struct PropertyKey {
        static let idKey = "id"
        static let nameKey = "name"
        static let ratingKey = "rating"
        static let iconKey = "icon"
        static let latKey = "lat"
        static let lngKey = "lng"
        static let photoReferenceKey = "photoReference"
        static let maxWidthKey = "maxWidth"
        static let typesKey = "types"
        static let vicinityKey = "vicinity"
        static let formattedAddressKey = "formattedAddress"
    }
    
    var id: String
    var name: String
    var rating: Double?
    var icon: URL?
    var photoReference: String?
    var maxWidth: Int?
    var types: [String]
    var vicinity: String?
    var formattedAddress: String?
    var location: CLLocation?
    var categories: String? {
        get {
            if types.count > 0 {
                var finalString = ""
                for (index, type) in types.enumerated() {
                    if index == 0 {
                        finalString.append(type)
                    } else {
                        finalString.append(", \(type)")
                    }
                }
                return finalString
            } else {
                return nil
            }
        }
    }
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String else {
            return nil
        }
        
        guard let name = json["name"] as? String else {
            return nil
        }
        
        let rating = json["rating"] as? Double
        
        let categories = json["types"] as? [String] ?? []
        
        if let vicinity = json["vicinity"] as? String {
            self.vicinity = vicinity
        }
        
        if let img_url = json["icon"] as? String {
            self.icon = URL(string: img_url)
        }
        if let photos = json["photos"] as? [[String: Any]]{
            for photo in photos {
                if let photoReference = photo["photo_reference"] as? String {
                    self.photoReference = photoReference
                }
                if let maxWidth = photo["width"] as? Int {
                    self.maxWidth = maxWidth
                }
            }
        }
        
        if let geometry = json["geometry"] as? [String: Any] {
            if let location = geometry["location"] as? [String: Any],
                let lat = location["lat"] as? Double,
                let lng = location["lng"] as? Double {
                    self.location = CLLocation(latitude: lat, longitude: lng)
            }
            
        }
        if let formattedAddress = json["formatted_address"] as? String {
            self.formattedAddress = formattedAddress
            
        }
        
        self.id = id
        self.name = name
        self.types = categories
        self.rating = rating

    }
        
    //MARK: - NSCoding
        
    init(id: String, name: String, rating: Double?, location: CLLocation?, icon: URL?, photoReference: String?, maxWidth: Int?, types: [String], vicinity: String?, formattedAddress: String?) {
            
        self.id = id
        self.name = name
        self.rating = rating
        self.location = location
        self.icon = icon
        self.photoReference = photoReference
        self.maxWidth = maxWidth
        self.types = types
        self.vicinity = vicinity
        self.formattedAddress = formattedAddress
        
    }
    
    func encode(with aCoder: NSCoder)
    
    {
        aCoder.encode(id, forKey: PropertyKey.idKey)
        aCoder.encode(name, forKey: PropertyKey.ratingKey)
        if let rating = rating {
            aCoder.encode(rating, forKey: PropertyKey.ratingKey)
            
        }
        if let locationCoordinate = location?.coordinate {
            aCoder.encode(Double(locationCoordinate.latitude), forKey: PropertyKey.latKey)
            aCoder.encode(Double(locationCoordinate.longitude), forKey: PropertyKey.lngKey)
            
        }
        aCoder.encode(icon?.absoluteString, forKey: PropertyKey.iconKey)
        aCoder.encode(photoReference, forKey: PropertyKey.photoReferenceKey)
        if let maxWidth = maxWidth {
            aCoder.encode(maxWidth, forKey: PropertyKey.maxWidthKey)
        }
        aCoder.encode(types, forKey: PropertyKey.typesKey)
        aCoder.encode(vicinity, forKey: PropertyKey.vicinityKey)
        aCoder.encode(formattedAddress, forKey: PropertyKey.formattedAddressKey)
        
    }
            
    required convenience init?(coder aDecoder: NSCoder) {
            
        var icon: URL?
        var location: CLLocation?
            
        let id = aDecoder.decodeObject(forKey: PropertyKey.idKey) as! String
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        let rating = aDecoder.decodeDouble(forKey: PropertyKey.ratingKey)
        if let iconStr = aDecoder.decodeObject(forKey: PropertyKey.iconKey) as? String {
            icon = URL(string: iconStr)
            
        }
            
        let lat = aDecoder.decodeDouble(forKey: PropertyKey.latKey)
        let lng = aDecoder.decodeDouble(forKey: PropertyKey.lngKey)
        location = CLLocation(latitude: lat, longitude: lng)
        let photoReference = aDecoder.decodeObject(forKey: PropertyKey.photoReferenceKey) as? String
        let maxWidth = aDecoder.decodeObject(forKey: PropertyKey.maxWidthKey) as? Int
        let types = aDecoder.decodeObject(forKey: PropertyKey.typesKey) as? [String] ?? []
        let vicinity = aDecoder.decodeObject(forKey: PropertyKey.vicinityKey) as? String
        let formattedAddress = aDecoder.decodeObject(forKey: PropertyKey.formattedAddressKey) as? String
        self.init(id: id, name: name, rating: rating, location: location, icon: icon, photoReference: photoReference, maxWidth: maxWidth, types: types, vicinity: vicinity, formattedAddress: formattedAddress)
        
    }
    //MARK: Archiving Paths
            
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("PlacesOfInterest")
    
}



