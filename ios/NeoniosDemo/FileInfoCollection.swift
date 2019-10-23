//
//  FileInfoCollection.swift
//  Neon-Ios
//
//  Created by Temp on 29/08/19.
//  Copyright © 2019 Girnar. All rights reserved.
//

import Foundation

class FileInfoCollection {
    
    static let sharedInstance = FileInfoCollection()
    var fileInfo = [FileInfo]()
    var imageTagArray = [ImageTagModel]()
    var imageLocalPathSaved = NSCache<NSString, UIImage>()
    
    private init(){}
    
}
