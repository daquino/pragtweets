//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Daniel Aquino on 10/6/14.
//  Copyright (c) 2014 Pragmatic Programmers, LLC. All rights reserved.
//

import UIKit
import Social

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")

public class ViewController: UITableViewController {
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
        // Do any additional setup after loading the view, typically from a nib.
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
    
    override public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
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
        if(parsedTweet.userAvatarURL != nil) {
            cell.avatarImageView.image = UIImage (data: NSData (contentsOfURL: parsedTweet.userAvatarURL!))
        }
        return cell
    }
    
    @IBAction func handleTweetButtonTapped(sender: UIButton) {
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
        self.tableView.reloadData()
    }
    
    
}

