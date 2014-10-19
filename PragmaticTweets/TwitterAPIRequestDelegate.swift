//
//  TwitterAPIRequestDelegate.swift
//  PragmaticTweets
//
//  Created by Daniel Aquino on 10/18/14.
//  Copyright (c) 2014 Pragmatic Programmers, LLC. All rights reserved.
//

import Foundation

protocol TwitterAPIRequestDelegate {
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!)
}