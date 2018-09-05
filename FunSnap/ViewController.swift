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
            }
        }
        
    }
    
}

