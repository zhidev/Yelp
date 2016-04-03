//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Implemented by Douglas Li 2/02/16
//  Copyright (c) 2016 Douglas Li. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {

    var businesses: [Business]!	
    @IBOutlet var tableView: UITableView!
    var filteredBusinesses: [Business]!
    
    
    var searchBar: UISearchBar?
    var searchController: UISearchController?
    var offset: Int = 20
    var isMoreDataLoading = false

    
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
        
        
        loadData()

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
    
    func loadData(){
        Business.searchWithTerm("", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            print("Beep Boop")
            if businesses != nil{
                self.businesses = businesses
                self.filteredBusinesses = self.businesses // I guess i keep this?
                
                self.tableView.reloadData()
                self.isMoreDataLoading = false

                /*for business in businesses {
                    
                    print(business.name!)
                    print(business.address!)
                }*/
                print("BUSINESS COUNT: \(businesses.count)")
            }
        })
    }
    
    /* Infinite scroll */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            /* If we reach the bottom of the table view */
            if(tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height)){
                print("Starting the infinite scroll view")
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    /* Load More Data */
    
    func loadMoreData(){
        if(businesses != nil){
        Business.searchWithTerm("", offset: offset, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            print("LoadMoreData")
            if businesses != nil{
                self.businesses.appendContentsOf(businesses)
                self.filteredBusinesses = self.businesses
                self.isMoreDataLoading = false
                self.tableView.reloadData()
                self.offset += 20
                /*for business in businesses {
                    
                    print(business.name!)
                    print(business.address!)
                }*/
                print("BUSINESS COUNT AFTER ADDING: \(businesses.count)")
            }
        })
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
