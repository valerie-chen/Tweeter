//
//  SearchedViewController.swift
//  Tweeter
//
//  Created by Valerie Chen on 7/1/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit

class SearchedViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
//    var searchText: String?
    
    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var allTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var topTweets: [Tweet]!
    var allTweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTableView.delegate = self
        topTableView.dataSource = self
        topTableView.rowHeight = UITableViewAutomaticDimension;
        topTableView.estimatedRowHeight = 100.0
        
        allTableView.delegate = self
        allTableView.dataSource = self
        allTableView.hidden = true
        allTableView.rowHeight = UITableViewAutomaticDimension;
        allTableView.estimatedRowHeight = 100.0
        
        searchBar.delegate = self
        
        // searchTextField.text = searchText

        // Do any additional setup after loading the view.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        retrieveTweets()
        searchBar.resignFirstResponder()
    }
    
    func retrieveTweets(){
        print("in retrieveTweets")
        let client = TwitterClient.sharedInstance
        client.searchPopularPosts(searchBar.text!, success: { (tweets: [Tweet]) in
            self.topTweets = tweets
            self.topTableView.reloadData()
            print("retrieved Popular")
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
        client.searchAllPosts(searchBar.text!, success: { (tweets: [Tweet]) in
            self.allTweets = tweets
            self.allTableView.reloadData()
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.topTableView {
            if topTweets != nil { // could this cause any problems?
                return topTweets.count
            } else {
                return 0
            }
        } else {
            if allTweets != nil { // could this cause any problems?
                return allTweets.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.topTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("TopTweetCell", forIndexPath: indexPath) as! TweetCell
            let tweet = topTweets[indexPath.row]
            cell.tweet = tweet
            print("yay")
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("AllTweetCell", forIndexPath: indexPath) as! TweetCell
            let tweet = allTweets[indexPath.row]
            cell.tweet = tweet
            return cell
        }
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        if (segmentedControl.selectedSegmentIndex == 0) {
            topTableView.hidden = false
            allTableView.hidden = true
        } else if (segmentedControl.selectedSegmentIndex == 1) {
            topTableView.hidden = false
            allTableView.hidden = false
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "topTweetToDetailSegue") {
            let destinationVC = segue.destinationViewController as! TweetDetailViewController
            let indexPath = topTableView.indexPathForSelectedRow
            let tweet = topTweets[indexPath!.row]
            destinationVC.tweet = tweet
            self.topTableView.deselectRowAtIndexPath(indexPath!, animated: true)
        } else if (segue.identifier == "allTweetToDetailSegue") {
            let destinationVC = segue.destinationViewController as! TweetDetailViewController
            let indexPath = allTableView.indexPathForSelectedRow
            let tweet = allTweets[indexPath!.row]
            destinationVC.tweet = tweet
            self.allTableView.deselectRowAtIndexPath(indexPath!, animated: true)
        } else if (segue.identifier == "searchAllReplyToComposeSegue") {
            let cell = sender?.superview!!.superview as! TweetCell
            let myTableView = cell.superview!.superview as! UITableView
            let indexPath = myTableView.indexPathForCell(cell)
            let tweet = allTweets[indexPath!.row]
            let destinationVC = segue.destinationViewController as! ComposeTweetViewController
            destinationVC.inReplyTo = tweet
        } else if (segue.identifier == "searchTopReplyToComposeSegue") {
            let cell = sender?.superview!!.superview as! TweetCell
            let myTableView = cell.superview!.superview as! UITableView
            let indexPath = myTableView.indexPathForCell(cell)
            let tweet = topTweets[indexPath!.row]
            let destinationVC = segue.destinationViewController as! ComposeTweetViewController
            destinationVC.inReplyTo = tweet
        }
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

}
