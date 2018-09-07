//
//  UIImage+Load.swift
//  FunSnap
//
//  Created by Bruce Bookman on 9/6/18.
//  Copyright © 2018 Bruce Bookman. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {
    
    func load(from urlString: String){
        guard let imageURL = URL(string: urlString) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: imageURL)
            let image = UIImage(data: data)
            self.image = image
        } catch {
            
        }
    }
}

extension UIImage {
    
    static func load(from urlString: String) -> UIImage? {
        guard let imageURL = URL(string: urlString),
            let data = try? Data(contentsOf: imageURL) else {
                return nil
        }
        return UIImage(data: data)
    }
}
