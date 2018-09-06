//
//  ViewController.swift
//  FunSnap
//
//  Created by Bruce Bookman on 8/31/18.
//  Copyright © 2018 Bruce Bookman. All rights reserved.
//

import UIKit
import SCSDKLoginKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func didTapLogin(_ sender: UIButton) {
        SCSDKLoginClient.login(from: self) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if success {
                print("Login Successful")
                self.getUserDetails()
            }
        }
        
    }
    
    
    func getUserDetails() {
        
        let graphQLQuery = "{me{displayName, bitmoji{avatar}, externalId}}"
        
        let variables = ["page": "bitmoji"]
        
        SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: variables, success: { (resources: [AnyHashable: Any]?) in
            guard let resources = resources,
                let data = resources["data"] as? [String: Any],
                let me = data["me"] as?  [String: Any] else { return }
            
            let displayName = me["displayName"] as? String
            
            print((String(describing: displayName)))
            
            var bitmojiAvatarUrl: String?
            if let bitmoji = me["bitmoji"] as? [String: Any] {
                bitmojiAvatarUrl = bitmoji["avatar"] as? String
                print((String(describing: bitmojiAvatarUrl)))
            }
        }, failure: { (error: Error?, isUserLoggedOut: Bool) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    
    
}

