//
//  ViewController.swift
//  FunSnap
//
//  Created by Bruce Bookman on 8/31/18.
//  Copyright © 2018 Bruce Bookman. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import SCSDKBitmojiKit


class ViewController: UIViewController {

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var avatarUIImageView: UIImageView!
    @IBOutlet weak var lblDisplayName: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
           prepareLoginView()
    }

    @IBAction func didTapLogin(_ sender: UIButton) {
        SCSDKLoginClient.login(from: self) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if success {
                print("Login Successful")
                self.getDisplayName()
                self.getAvatar()
                DispatchQueue.main.async {
                    self.btnLogout.isHidden = false
                    self.btnLogin.isHidden = true
                }
                
            }
        }
        
    }
    
    
    func getDisplayName() {
        
        let graphQLQuery = "{me{displayName, bitmoji{avatar}, externalId}}"
        
        let variables = ["page": "bitmoji"]
        
        SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: variables, success: { (resources: [AnyHashable: Any]?) in
            guard let resources = resources,
                let data = resources["data"] as? [String: Any],
                let me = data["me"] as?  [String: Any] else { return }
            
            let displayName = me["displayName"] as? String
            
            DispatchQueue.main.async {
                self.lblDisplayName.text = displayName
                self.lblDisplayName.isHidden = false
            }
            
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
    
    
    func getAvatar(){
        SCSDKBitmojiClient.fetchAvatarURL { (avatarUrl, error) in
            if let error = error {
                print(error.localizedDescription)
            }
    
            DispatchQueue.main.async {
            
            
                if let avatarUrl = avatarUrl {
                    self.avatarUIImageView.load(from: avatarUrl)
                    self.avatarUIImageView.isHidden = false
                }
            }
        }
        
    }
    
    @IBAction func didTapLogout(_ sender: UIButton) {
        SCSDKLoginClient.unlinkCurrentSession(completion:  { (success) in
            
            if success {
                DispatchQueue.main.async {
                    self.prepareLoginView()
                }
                
            } else {
                
                print("Error on logout")
            }
        })
    }
    
    func prepareLoginView(){
        btnLogout.isHidden = true
        btnLogin.isHidden = false
        avatarUIImageView.isHidden = true
        lblDisplayName.isHidden = true
    }

    
}

