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
        // Do any additional setup after loading the view, typically from a nib.
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
        let cell = tableView.dequeueReusableCellWithIdentifier("UserAndTweetCell") as UITableViewCell
        let parsedTweet = parsedTweets[indexPath.row]
        cell.textLabel!.text = parsedTweet.userName
        cell.detailTextLabel!.text = parsedTweet.tweetText
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

