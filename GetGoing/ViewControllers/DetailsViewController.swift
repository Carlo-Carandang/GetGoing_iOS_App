//
//  DetailsViewController.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-17.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageViewAspectRationLayoutConstraint: NSLayoutConstraint!
    
    var place: PlaceOfInterest!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = place.name
        addressLabel.text = place.formattedAddress
        updateImageView()
        setMapViewCoordinate()
        
    }
    
    func setMapViewCoordinate(){
        
      //  mapView.delegate = self as! MKMapViewDelegate
        
        if let coordinate = place.location?.coordinate {
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
            centerMapOnLocation(annotation.coordinate)
            
            mapView.showsUserLocation = true
            
        }
        
    }
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D) {
        let radius = Constants.radius
        let region = MKCoordinateRegionMakeWithDistance(location, CLLocationDistance(Double(radius) * 2.0), CLLocationDistance(Double(radius) * 2))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "reusePin")
        
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        view.pinTintColor = UIColor.green
        
        return view
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print("tapped Info button")
        let location = view.annotation
        let launchingOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        if let coordinate = view.annotation?.coordinate {
            location?.mapItem(coordinate:coordinate).openInMaps(launchOptions: launchingOptions)
            
        }
        
    }
    
    func updateImageView(){
        if let photoReference = place.photoReference, let maxWidth = place.maxWidth {
            GooglePlacesAPI.requestPhoto(photoreference: photoReference, maxWidth: maxWidth, completion: { (status, image) in
                DispatchQueue.main.async {
                    if let img = image {
                        let aspectRatio = img.size.height / img.size.width
                //        self.imageViewAspectRationLayoutConstraint.constant = aspectRatio
                        
                    }
                    self.photoImageView.image = image
                }
            })
        }
    }
}

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
//    }

extension MKAnnotation {
        func mapItem(coordinate: CLLocationCoordinate2D)-> MKMapItem {
            let placeMark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placeMark)
            return mapItem
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


