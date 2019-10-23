//
//  MyImageCell.swift
//  Neon-Ios
//
//  Created by Girnar on 1/28/19.
//  Copyright © 2019 Girnar. All rights reserved.
//

import UIKit

//protocol MyImageCellProtocol : class {
//    func deleteButtonTapped(button: UIButton)
//
//}

class MyImageCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var tagName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
   // weak var delegate: MyImageCellProtocol?
    
   // typealias TapClosure = () -> Void
    
   // var buttonTapped: TapClosure?
    
//    @IBAction func buttonTouchUpInside(sender: UIButton) {
//        buttonTapped?()
//        delegate?.deleteButtonTapped(button: sender)
//    }

    
}
