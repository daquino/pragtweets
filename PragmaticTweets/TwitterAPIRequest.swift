//
//  TwitterAPIRequest.swift
//  PragmaticTweets
//
//  Created by Daniel Aquino on 10/18/14.
//  Copyright (c) 2014 Pragmatic Programmers, LLC. All rights reserved.
//

import Social
import Accounts

class TwitterAPIRequest: NSObject {
    func sendTwitterRequest(requestURL: NSURL!, params: Dictionary<String, String>, delegate: TwitterAPIRequestDelegate?) {
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil, completion: {
            (granted: Bool, error: NSError!) -> Void in
            if(!granted) {
                println("account access not granted")
            }
            else {
                let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
                if(twitterAccounts.count == 0) {
                    println("no twitter accounts configured")
                    return
                }
                else {
                    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: params)
                    request.account = twitterAccounts[0] as ACAccount
                    request.performRequestWithHandler({
                        (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
                        if delegate != nil {
                            delegate!.handleTwitterData(data, urlResponse: urlResponse, error: error, fromRequest: self)
                        }
                    })
                }
            }
        })
    }
}
