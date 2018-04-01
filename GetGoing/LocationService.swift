//
//  LocationService.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-17.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    func tracingLocation(_currentLocation: CLLocation)
    func tracingLocationDidFailWithError(_error: Error)
}

class LocationService: NSObject, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    static let sharedInstance = LocationService()
    weak var delegate: LocationServiceDelegate?
    
    private override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
    }

    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else {
            return
        }
        
        // singleton for get last(current) location
        self.currentLocation = location
        
        // use for real time update location
        updateLocation(location)
    }
    
    // Private function
    private func updateLocation(_ currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(_currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(_ error: Error) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(_error: error)
    }
}
