//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Implemented by Douglas Li 2/02/16
//  Copyright (c) 2016 Douglas Li. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var businesses: [Business]!	
    @IBOutlet var tableView: UITableView!
    var filteredBusinesses: [Business]!
    
    
    var searchBar: UISearchBar?
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar = UISearchBar()
        searchBar!.sizeToFit()
        
        searchController = UISearchController(searchResultsController: nil)
        
        /*self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        */
        navigationItem.titleView = searchBar
        
        searchBar!.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        Business.searchWithTerm("", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = self.businesses

            self.tableView.reloadData()
            
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBusinesses != nil {
            return filteredBusinesses!.count
        } else{
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath:  indexPath) as! BusinessCell
        cell.business = filteredBusinesses[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("detailed", sender: indexPath)
    }
    
    @IBAction func openSearch(sender: AnyObject) {
        searchBar!.hidden = !searchBar!.hidden
        if searchBar!.hidden == false{
            searchBar?.becomeFirstResponder()
        }else{
            searchBar?.resignFirstResponder()
        }
    }
    

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        if businesses == nil {
            businesses = filteredBusinesses
        }
        if let searchText = searchBar.text {
            if(searchText == "") {
                filteredBusinesses = businesses
                tableView.reloadData()
            } else {
                filteredBusinesses = searchText.isEmpty ? businesses : businesses?.filter({ (business:Business) -> Bool in
                    business.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                });
                tableView.reloadData()
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailed"{
            let indexPath = sender
            let detailedVC = segue.destinationViewController as! DetailedViewController
            let selected = filteredBusinesses![indexPath!.row]
            detailedVC.dbusiness = selected
            print("detailed potato")
        }
    }
}
