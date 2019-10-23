//
//  NeoniosDemo.swift
//  NeoniosDemo
//
//  Created by Deepak Sharma on 27/09/19.
//  Copyright © 2019 GirnarSoft. All rights reserved.
//

import Foundation
import UIKit

// Global namespace containing API for the `default` `Session` instance.
@objc
public class NeoniosDemo: NSObject {
    
   @objc public  func getHandler(json: String) -> String {
        print("called")
        
        return NeonImagesHandler.singleonInstance.getCurrentTag()
        
    }
   @objc public  func openNeutral() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigation = UINavigationController()
        
        return NeonImagesHandler.singleonInstance.openNeutralController(navigation: navigation, storyBoard: storyboard)
    }
    
}
