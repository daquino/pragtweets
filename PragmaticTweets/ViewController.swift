//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Daniel Aquino on 10/6/14.
//  Copyright (c) 2014 Pragmatic Programmers, LLC. All rights reserved.
//

import UIKit
import Social

public class ViewController: UIViewController {

    @IBOutlet public weak var twitterWebView: UIWebView!
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadTweets()
        // Do any additional setup after loading the view, typically from a nib.
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleShowMyTweetsTapped(sender: UIButton) {
        self.reloadTweets()
    }
    
    func reloadTweets() {
        let url = NSURL(string: "http://www.twitter.com/yomilayer3")
        let urlRequest = NSURLRequest(URL: url)
        self.twitterWebView.loadRequest(urlRequest)
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
}

