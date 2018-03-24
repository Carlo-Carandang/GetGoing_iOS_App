//
//  GooglePlacesAPI.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-10.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class GooglePlacesAPI: NSObject {
    fileprivate static let appLanguage = NSLocale.current.languageCode
    
    class func requestPlaces(for locationCoordinate: CLLocationCoordinate2D, param: String?, openNow: Bool = false, radius: Int, timeoutInterval: TimeInterval = 240.0, completion: @escaping (_ status: Int, _ message: String?, _ json: [String: Any]?) -> Void) {
    
        do{
            let session = URLSession.shared
            var urlComponents = URLComponents()
            urlComponents.host = Constants.host
            urlComponents.scheme = Constants.scheme
            urlComponents.path = Constants.textPlaceSearch
        
            urlComponents.queryItems = [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "key", value: Constants.apiKey)
            ]
            
            if let url = urlComponents.url {
                let request = NSMutableURLRequest(url: url,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: timeoutInterval)
                print("request \(String(describing: request.url))")
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        if error?._code == NSURLErrorTimedOut {
                            completion(408, nil, nil)
                            return
                            
                        } else if error?._code == NSURLErrorNotConnectedToInternet{
                            completion(1009, nil, nil)
                            
                        } else {
                            completion(500, "unknown error", nil)
                            return
                            
                        }
                        
                    } else {
                        if let jsonData = data, let jsonResponse = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                            print(jsonResponse ?? "no result")
                            completion(200, nil, jsonResponse)
                            
                        } else {
                            completion(500, nil, nil)
                        }
                    }
                })
                dataTask.resume()
            }
        }
    }
    
    class func requestDetails(placeId: String, completion: @escaping (_ status: Int, _ message: String?, _ json: [String: Any]?) -> Void) {
        do {
            let session = URLSession.shared
                
            var urlComponents = URLComponents()
            urlComponents.scheme = Constants.scheme
            urlComponents.host = Constants.host
            urlComponents.path = Constants.placePhotoSearch
                
            urlComponents.queryItems = [
                URLQueryItem(name: "placeid", value: placeId),
                URLQueryItem(name: "key", value: Constants.apiKey)
            ]
            
            if let url = urlComponents.url{
                let request = NSMutableURLRequest(url: url)
                    
                print("request \(String(describing: request.url))")
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if let jsonData = data, let jsonResponse = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                            print(jsonResponse ?? "no result")
                            completion(200, nil, jsonResponse)
                    } else {
                        completion(500, nil, nil)
                    }
                })
                dataTask.resume()
            }
        }
    }
}
