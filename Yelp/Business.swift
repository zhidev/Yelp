//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Implemented by Douglas Li 2/02/16
//  Copyright © 2016 Douglas Li All rights reserved.
//

import UIKit

class Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: NSURL?
    let categories: String?
    let distance: String?
    let ratingImageURL: NSURL?
    let reviewCount: NSNumber?
    
    
    let websiteURL: NSURL?
    var longitude: Double?
    var latitude: Double?
    /*var coordinate: NSDictionary?*/
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = NSURL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
            
            let coordinates = location!["coordinate"] as? NSDictionary
            if coordinates != nil {
                let lat = coordinates!["latitude"] as? Double
                let long = coordinates!["longitude"] as? Double
                if( (lat != nil) && (long != nil)){
                    self.latitude = lat
                    self.longitude = long
                }//end lat & long != nil
                /*self.coordinate = coordinates*/
                
            }//end if coordinates != nil
        }
        self.address = address
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joinWithSeparator(", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = NSURL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        let webURL = dictionary["url"] as? String
        if webURL != nil{
            websiteURL = NSURL(string: webURL!)
        } else{
            websiteURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
    }
    
    class func businesses(array array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([Business]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, completion: completion)
    }
    /* Inf load and scroll */
    class func searchWithTerm(term: String, offset: Int, completion: ([Business]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, offset: offset, completion: completion)
    }
    /* Map View */
    class func mapSearchWithTerm(term: String, latitude: NSNumber?, longitude: NSNumber?, categories: [String]?, completion: ([Business]!, error: NSError!) -> Void) -> Void {
        print("UGH")
        YelpClient.sharedInstance.searchWithTerm(term, latitude: latitude, longitude: longitude, sort: YelpSortMode.Distance, categories: categories, offset: 0, deals: false, completion: completion)
        print("Potato")
    }
}
