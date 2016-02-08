//
//  DetailedViewController.swift
//  Yelp
//
//  Created by Douglas on 2/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
class DetailedViewController: UIViewController {

    var dbusiness: Business!
    
    @IBOutlet var businessImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var buttonImage: UIButton!
    @IBOutlet var reviewView: UIImageView!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("BCELL name label is: \(BCell?.nameLabel)")
        // Do any additional setup after loading the view.
        businessImage.setImageWithURL(dbusiness.imageURL!)
        nameLabel.text = dbusiness.name
        addressLabel.text = dbusiness.address
        reviewView.setImageWithURL(dbusiness.ratingImageURL!)
        reviewLabel.text = "\(dbusiness.reviewCount!) Reviews"
        //buttonImage.setImage(businessImage.image, forState: UIControlState.Normal)
        
        print("latitude: \(dbusiness.latitude) longitude: \(dbusiness.longitude)")
        
        let centerLocation = CLLocation(latitude: dbusiness.latitude!, longitude: dbusiness.longitude!)
        goToLocation(centerLocation)
        
        
        print("Potato: \(dbusiness.name)")
        print("URL: \(dbusiness.websiteURL)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "yelpsegue"{
            let webVC = segue.destinationViewController as! WebViewController
            webVC.websiteURL = dbusiness.websiteURL!
        }
    }
    
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
}
