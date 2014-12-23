//
//  SizeClassOverridingViewController.swift
//  PragmaticTweets
//
//  Created by Daniel Aquino on 10/29/14.
//  Copyright (c) 2014 Pragmatic Programmers, LLC. All rights reserved.
//

import UIKit

class SizeClassOverridingViewController: UIViewController {
    
    var embeddedSplitVC: UISplitViewController?
    var screenNameForOpenURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedSplitViewSegue" {
            self.embeddedSplitVC = segue.destinationViewController as? UISplitViewController
        }
        else if segue.identifier == "ShowUserFromURLSegue" {
            if let userDetailVC = segue.destinationViewController as? UserDetailViewController {
                println("User name: \(self.screenNameForOpenURL)")
                userDetailVC.screenName = self.screenNameForOpenURL
            }
        }
    }
    
   
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if size.width > 480.0 {
            let overrideTraits = UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Regular)
            self.setOverrideTraitCollection(overrideTraits, forChildViewController: embeddedSplitVC!)
        }
        else {
            self.setOverrideTraitCollection(nil, forChildViewController: embeddedSplitVC!)
        }
    }
    
    @IBAction func unwindToSizeClassOverridingVC(segue: UIStoryboardSegue) {
        
    }
    
    

}
