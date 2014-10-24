//
//  ParsedTweet.swift
//  PragmaticTweets
//
//  Created by Daniel Aquino on 10/12/14.
//  Copyright (c) 2014 Pragmatic Programmers, LLC. All rights reserved.
//

import UIKit

class ParsedTweet: NSObject {
    var tweetText: String?
    var userName: String?
    var createdAt: String?
    var userAvatarURL: NSURL?
    var tweetIdString: String?
    
    override init() {
        super.init()
    }
    
    init (tweetText: String?, userName: String?, createdAt: String?, userAvatarURL: NSURL?) {
        super.init()
        self.tweetText = tweetText
        self.userName = userName
        self.createdAt = createdAt
        self.userAvatarURL = userAvatarURL
    }
   
}
