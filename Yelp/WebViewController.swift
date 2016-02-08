//
//  WebViewController.swift
//  Yelp
//
//  Created by Douglas on 2/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet var yelpView: UIWebView!
    
    var websiteURL: NSURL?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yelpView.loadRequest(NSURLRequest(URL: websiteURL!))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
