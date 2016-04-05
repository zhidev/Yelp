//
//  MapViewController.swift
//  Yelp
//
//  Created by Douglas on 4/4/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    
    @IBOutlet var mapView: MKMapView!
    
    var businessInArea: [Business]!
    //var singleBusiness : Business!
    var locationManager : CLLocationManager!
    var currentLocation : CLLocation!{
        didSet{
            print("Ara?")
            goToLocation(currentLocation)
            locationManager.stopUpdatingLocation()
            //populateMap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        mapView.delegate = self
        //populateMap()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func getCurrentLocation(){
        if let location = locationManager.location{
            print("getCurrLocation")
           currentLocation = location
            populateMap()
        }
    }
 
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print(" eh?")
        print(status.hashValue)
        if(status == CLAuthorizationStatus.NotDetermined){
            let alert = UIAlertController(title: "Notice", message: "You will be asked to allow the application to use your current location to find restaurants near you. Confirm if you want to allow this", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: .Default) { _ in
                self.locationManager.requestWhenInUseAuthorization()
                })
            alert.addAction(UIAlertAction(title: "No Thanks!", style: .Default) { _ in })//nothing happens if no
            self.presentViewController(alert, animated: true){}
        }
        if(status == CLAuthorizationStatus.AuthorizedWhenInUse){
            locationManager.startUpdatingLocation()
            print("Uhhhh?")
            getCurrentLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getCurrentLocation()
    }
    
    func populateMap(){
        searchNearby()
    }
    
    func searchNearby(){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var lat, long: CLLocationDegrees?
        if let currentLocation = currentLocation{
            lat = currentLocation.coordinate.latitude
            long = currentLocation.coordinate.longitude
        }else{
            lat = nil
            long = nil
        }
        Business.mapSearchWithTerm("restaurants", latitude: lat, longitude: long, categories: []) { (businessArray: [Business]!, error: NSError!) -> Void in
            print("Doot doot")
            if error == nil{
                print("Error free")
                self.businessInArea = businessArray
                self.addPinsFromBusinessInArea()
            }else{
                print(error.localizedDescription)
            }
        }
    }
    
    func addPinsFromBusinessInArea(){
        if businessInArea != nil{
            for businessObj in businessInArea {
                let pinLocation = CLLocationCoordinate2DMake(businessObj.latitude! , businessObj.longitude!)
                addAnnotationAtCoordinate(pinLocation, text: businessObj.name!)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, text: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = text
        mapView.addAnnotation(annotation)
        print("annotation added")
    }
}
