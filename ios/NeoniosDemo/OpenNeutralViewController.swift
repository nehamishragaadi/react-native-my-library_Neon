//
//  OpenNeutralViewController.swift
//  Neon-Ios
//
//  Created by Neha Mishra1 on 4/11/19.
//  Copyright © 2019 Girnar. All rights reserved.
//

import UIKit


class OpenNeutralViewController: UIViewController  {
    //    func setImageArray(imageArray: [String : UIImage]) {
    //        print("In set image array")
    //        receivedArray = imageArray
    //    }
    var tags: String = "Mandatory Tags\n\n"
    var nextVC : CameraViewController!
    var imageTagArray : [ImageTagModel] = []
    var receivedArray:[String:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func horizontalPriorityFileButonAction(_ sender: Any) {
    
    }
    
    @IBAction func horizontalOnlyFileButtonAction(_ sender: Any) {
    
    }
    
    @IBAction func horizontalPriorityButtonACtion(_ sender: Any) {
    
    }
    
    @IBAction func horizontalOnlyButtonAction(_ sender: Any) {
    
    }
    
    
    @IBAction func gridPriorityFileButtonAction(_ sender: Any) {
    
    }
    
    @IBAction func gridOnlyFileButtonAction(_ sender: Any) {
    
    }
    
    
    @IBAction func gridOnlyButtonAction(_ sender: Any) {
    
    }
    
    @IBAction func gridPriorityButtonAction(_ sender: Any) {
    
    }
    
    @IBAction func cameraOnlyButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func cameraPriorityButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func openNeutralButtonAction(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
