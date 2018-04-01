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

class GooglePlacesAPI{
    class func requestPlaces(query: String?, completion: @escaping (_ status: Int, _ errorMessage: String?, _ json:[String: Any]?) ->Void) {

//        let session = URLSession.shared
        var urlComponents = URLComponents()
        urlComponents.host = Constants.host
        urlComponents.scheme = Constants.scheme
        urlComponents.path = Constants.textPlaceSearch
        
        urlComponents.queryItems =
            [URLQueryItem(name: "query", value: query),
             URLQueryItem(name: "key", value: Constants.apiKey)
            ]
        print(urlComponents)

        if let url = urlComponents.url {
            let request = NSMutableURLRequest(url: url)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                if error != nil {
                    completion(500,"unknown error",nil)
                    return
                }
                else{
                    if let responseData = data, let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]{
                        completion(200,nil, json)
                    }
                    else{
                        completion(500,"unknown error",nil)
                        return
                    }
                }
            })
            dataTask.resume()
        }
    }

    class func requestPlaces(coordinate: CLLocationCoordinate2D, keyword: String?, completion: @escaping (_ status: Int, _ errorMessage: String?, _ json:[String: Any]?) -> Void) {
    
        //let session = URLSession()
    
        var urlComponents = URLComponents()
        urlComponents.host = Constants.host
        urlComponents.scheme = Constants.scheme
        urlComponents.path = Constants.coordinatePlaceSearch
    
        urlComponents.queryItems =
            [URLQueryItem(name: "location", value: "\(coordinate.latitude),\(coordinate.longitude)"),
             URLQueryItem(name:"radius", value:  String(Constants.radius)),
             URLQueryItem(name: "key", value: Constants.apiKey)
        ]
    
        print(urlComponents)
        if let keyword = keyword {
            urlComponents.queryItems?.append(URLQueryItem(name: "keyword", value: keyword))
        }
    
        if let url = urlComponents.url{
            let request = NSMutableURLRequest(url: url)
        
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest,completionHandler: {(data, response, error) in
                if error != nil{
                    completion(500,"unknown error",nil)
                    return
                }
                else{
                    if let responseData = data, let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]{
                        completion(200,nil, json)
                    }
                    else{
                        completion(500,"unknown error",nil)
                        return
                    }
                }
            })
            dataTask.resume()
        }
    }

    class func requestPhoto(photoreference: String, maxWidth: Int, completion: @escaping (_ status: Int, UIImage?) -> Void) {
        do {
            let session = URLSession.shared
            var urlComponents = URLComponents()
            urlComponents.scheme = Constants.scheme
            urlComponents.host = Constants.host
            urlComponents.path = Constants.placePhotoSearch
            urlComponents.queryItems = [
                URLQueryItem(name: "photoreference", value: photoreference),
                URLQueryItem(name: "maxwidth", value: String(maxWidth)),
                URLQueryItem(name: "key", value: Constants.apiKey)
            ]
            if let url = urlComponents.url{
                let request = NSMutableURLRequest(url: url)
                print("request \(String(describing: request.url))")
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler:
                    { (data, response, error) -> Void in
                        if let data = data {
                            let image = UIImage(data: data)
                            completion(200, image)
                            return
                        } else {
                            completion(500, nil)
                            return
                        }
                })
                dataTask.resume()
            }
        }
    }
}

