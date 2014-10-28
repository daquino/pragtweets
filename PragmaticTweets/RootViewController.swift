//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Daniel Aquino on 10/6/14.
//  Copyright (c) 2014 Pragmatic Programmers, LLC. All rights reserved.
//

import UIKit
import Social
import Accounts

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")

public class RootViewController: UITableViewController, TwitterAPIRequestDelegate, UISplitViewControllerDelegate {
    var parsedTweets : Array<ParsedTweet> =  [
        ParsedTweet(tweetText: "iOS SDK Development now in print swift programming ftw!", userName: "@pragprog", createdAt: "2014-08-20 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Math is cool", userName: "@redqueencoder", createdAt: "2014-08-16 16:44:30 EDIT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Anime is cool", userName: "@invalidname", createdAt: "2014-07031 16:44:30 EDT", userAvatarURL: defaultAvatarURL)
    ]

    public override func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        var refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresher
        if self.splitViewController != nil {
            self.splitViewController!.delegate = self
        }
    }
    
    @IBAction func handleRefresh(sender: AnyObject?) {
        self.parsedTweets.append(ParsedTweet(tweetText: "New row", userName: "@refresh", createdAt: NSDate().description, userAvatarURL: defaultAvatarURL));
        reloadTweets()
        refreshControl!.endRefreshing()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetCell") as ParsedTweetCell
        let parsedTweet = parsedTweets[indexPath.row]
        cell.userNameLabel.text = parsedTweet.userName
        cell.tweetTextLabel.text = parsedTweet.tweetText
        cell.createdAtLabel.text = parsedTweet.createdAt
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
            {() -> Void in
                let avatarImage = UIImage(data: NSData(contentsOfURL: parsedTweet.userAvatarURL!)!)
                dispatch_async(dispatch_get_main_queue(),
                    { () -> Void in
                        if(cell.userNameLabel.text == parsedTweet.userName) {
                            cell.avatarImageView.image = avatarImage
                        }
                        else {
                            println("oops wrong cell, nevermind")
                        }
                    })
            })
        return cell
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let parsedTweet = parsedTweets[indexPath.row]
        if self.splitViewController != nil {
            if(self.splitViewController!.viewControllers.count > 1) {
                if let tweetDetailVC = self.splitViewController!.viewControllers[1] as? TweetDetailViewController {
                    tweetDetailVC.tweetIdString = parsedTweet.tweetIdString;
                }
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    @IBAction func handleTweetButtonTapped(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let message = NSBundle.mainBundle().localizedStringForKey("I just finished the first project in iOS 8 SDK Development. #pragios8", value: "", table: nil)
            let tweetVC = SLComposeViewController (forServiceType: SLServiceTypeTwitter)
            tweetVC.setInitialText(message)
            self.presentViewController(tweetVC, animated: true, completion: nil)
        }
        else {
            println("Can't send tweet")
        }
    }
    
    func reloadTweets() {
        let twitterParams: Dictionary = ["count": "100"]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        let request = TwitterAPIRequest()
        request.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let dataValue = data {
            var parseError: NSError? = nil
            let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(0), error: &parseError)
            if parseError != nil {
                return
            }
            if let jsonArray = jsonObject as? Array<Dictionary<String, AnyObject>> {
                self.parsedTweets.removeAll(keepCapacity: true)
                for tweetDict in jsonArray {
                    let parsedTweet = ParsedTweet()
                    parsedTweet.tweetText = tweetDict["text"] as? NSString
                    parsedTweet.createdAt = tweetDict["created_at"] as? NSString
                    let userDict = tweetDict["user"] as NSDictionary
                    parsedTweet.userName = userDict["name"] as? NSString
                    parsedTweet.userAvatarURL = NSURL(string: userDict["profile_image_url"] as NSString!)
                    parsedTweet.tweetIdString = tweetDict["id_str"] as? NSString
                    self.parsedTweets.append(parsedTweet)
                    dispatch_async(dispatch_get_main_queue(),
                        { () -> Void in
                            self.tableView.reloadData()
                        })
                }
            }
        }
        else {
            println("JsonObject = \(data)")
            println("handleTwitterData received no data")
        }
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTweetDetailsSegue" {
            if let tweetDetailVC = segue.destinationViewController as? TweetDetailViewController {
                let row = self.tableView!.indexPathForSelectedRow()!.row
                let parsedTweet = parsedTweets[row] as ParsedTweet
                tweetDetailVC.tweetIdString = parsedTweet.tweetIdString
            }
        }
    }
    
    public func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }
}