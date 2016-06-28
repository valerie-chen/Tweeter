//
//  HomeViewController.swift
//  Tweeter
//
//  Created by Valerie Chen on 6/27/16.
//  Copyright © 2016 Valerie Chen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 100.0;
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
        
//        // ... Create the NSURLRequest (myRequest) ...
//        
//        // Configure session so that completion handler is executed on main UI thread
//        let session = NSURLSession(
//            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
//            delegate:nil,
//            delegateQueue:NSOperationQueue.mainQueue()
//        )
//        
//        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest, completionHandler: { (data, response, error) in
//                                                                        
//            // ... Use the new data to update the data source ...
//                                                                        
//            // Reload the tableView now that there is new data
//            self.myTableView.reloadData()
//                                                                        
//            // Tell the refreshControl to stop spinning
//            refreshControl.endRefreshing()
//        });
//        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil { // could this cause any problems?
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
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
