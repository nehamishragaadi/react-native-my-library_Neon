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
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    guard let window = UIApplication.shared.windows.first else {
//      return
//    }
    
    
    let bundle = Bundle.init(for: ViewController.self)
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    let navigation = UINavigationController(rootViewController: viewController)
    if let rootViewController = UIApplication.topViewController() {
//        navigation.pushViewController(viewController, animated: true)
//      viewController.navigation = navigation
      DispatchQueue.main.async {
         rootViewController.present(navigation, animated: false, completion: nil)
      }
     
    }

    return NeonImagesHandler.singleonInstance.openNeutralController(navigation: navigation, storyBoard: storyboard)
    }
 

}


extension UIApplication {
  class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

          if let top = moreNavigationController.topViewController, top.view.window != nil {
            return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
            return topViewController(base: selected)
            }
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}
