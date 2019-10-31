//
//  NeonImagesHandler.swift
//  Neon-Ios
//
//  Created by Akhilendra Chauhan on 08/02/19.
//  Copyright © 2019 Girnar. All rights reserved.
//

import Foundation

import UIKit

public class NeonImagesHandler {
    
    public static let singleonInstance = NeonImagesHandler()
    
    
    
    var clearInstance : Bool!
    
    var imagesCollection = [FileInfo]()
    
    var imageTagArray = [ImageTagModel]()
    
    var neutralEnabled : Bool!
    
    var imageResultListener : OnImageCollectionListener!
    
    var livePhotosListener : LivePhotosListener!
    
    var livePhotoNextTagListener : LivePhotoNextTagListener!
    
    var currentTag : String = ""
    
    var requestCode : Int!
    
    var imageLocalPathSaved = NSCache<NSString, UIImage>()
    
    
    
    private init(){
        
        
        
    }
    
    
    
    
    
    open func addCustomObjectInArray() -> String {
        
        
        
        let jsonString = """

{

        "tagId" : "1" ,

        "tagName" : "Tag2" ,

        "noOfPhotos" : 5,

        "mandatory" : false,

        "isSelected" : true,

        "location" : 4,

      

}

"""
        
        
        
        //        let jsonString = """
        
        //{
        
        //        "libraryMode" : 0 ,
        
        //        "numberOfPhotos" : 5,
        
        //        "cameraFacing" : "0",
        
        //        "cameraOrientation" :0,
        
        //        "cameraViewType" : 0,
        
        //        "galleryViewType" : 0,
        
        //        "tagEnabled" : true,
        
        //        "flashEnabled" : 0,
        
        //        "cameraSwitchingEnabled" : false,
        
        //        "cameraToGallerySwitchEnabled" : false,
        
        //        "enableFolderStructure" : true,
        
        //        "galleryToCameraSwitchEnabled" : false,
        
        //        "isRestrictedExtensionJpgPngEnabled" : true,
        
        //        "enableImageEditing" : false,
        
        //        "locationRestrictive" : false,
        
        //        "hideCameraButtonInNeutral" : false,
        
        //        "hideGalleryButtonInNeutral" : false,
        
        //        "hasOnlyProfileTag" : false,
        
        //}
        
        //"""
        
        
        
        
        
        if let jsonData = jsonString.data(using: .utf8)
            
        {
            
            let decoder = JSONDecoder()
            
            
            
            do {
                
                let configureValue = try decoder.decode(ImageTagModel.self, from: jsonData)
                
                print(configureValue.getTagId() as Any)
                
                print(configureValue.getTagName() as Any)
                
                print(configureValue.isMandatory() as Any)
                
                print(configureValue.getloction() as Any)
                
                print(configureValue.getIsSelected() as Any)
                
                print(configureValue.getNumberOfPhotos() as Any)
                
                
                
                
                
                
                
            } catch {
                
                print(error.localizedDescription)
                
            }
            
        }
        
        
        
        
        
        
        
        imageTagArray.removeAll()
        
        for i in 0...2 {
            
            if i % 2 == 0 {
                
                let fileTag = ImageTagModel.init(tagId: "\(i + 1)", tagName: "*Tag \(i + 1)", mandatory: true, noOfPhotos: i, location: nil, isSelected: false)
                
                self.imageTagArray.append(fileTag)
                
            }else{
                
                let fileTag = ImageTagModel.init(tagId: "\(i + 1)", tagName: "Tag \(i + 1)", mandatory: false, noOfPhotos: i, location: nil, isSelected: false)
                
                self.imageTagArray.append(fileTag)
                
            }
            
        }
        
        
        
        var tags = ""
        
        for tagModel in imageTagArray {
            
            if tagModel.isMandatory() {
                
                tags = tags + "\(tagModel.getTagName())" + "\n"
                
            } else {
                
                tags = tags + tagModel.getTagName() + "\n"
                
            }
            
            
            
        }
        
        return tags
        
    }
    
    
    
    open func openNeutralController(navigation: UINavigationController, storyBoard: UIStoryboard) {
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        navigation.pushViewController(viewController, animated: true)
        
    }
    
    
    
    open func getNumberOfPhotosCollected() -> Int {
        
        
        
        return self.imageTagArray.map({$0.getNumberOfPhotos()}).reduce(0, +)
        
    }
    
    
    
    open func getImageResultListener() -> OnImageCollectionListener {
        
        return imageResultListener
        
    }
    
    
    
    open func getLivePhotosListener() -> LivePhotosListener {
        
        return livePhotosListener
        
    }
    
    
    
    public func getLivePhotoNextTagListener() -> LivePhotoNextTagListener {
        
        return livePhotoNextTagListener
        
    }
    
    
    
    public func setLivePhotoNextTagListener(livePhotoNextTagListener : LivePhotoNextTagListener) -> Void {
        
        self.livePhotoNextTagListener = livePhotoNextTagListener
        
    }
    
    
    
    public func getCurrentTag() -> String {
        
        return currentTag
        
    }
    
    
    
    public func setCurrentTag(currentTag : String) -> Void {
        
        self.currentTag = currentTag
        
    }
    
    
    
    //    public func getGenericParam() -> IParam {
    
    //        if galleryParam != nil{
    
    //            return galleryParam;
    
    //        }
    
    //        else if cameraParam != nil {
    
    //            return cameraParam;
    
    //        }
    
    //        else {
    
    //            return neutralParam;
    
    //        }
    
    //    }
    
    
    
    public func isNeutralEnabled() -> Bool {
        
        return neutralEnabled
        
    }
    
    
    
    public func setNeutralEnabled(neutralEnabled : Bool) -> Void {
        
        self.neutralEnabled = neutralEnabled
        
    }
    
    
    
    //    public func getNeutralParam() -> INeutralParam {
    
    //        return neutralParam
    
    //    }
    
    //
    
    //    public func setNeutralParam( neutralParam : INeutralParam) -> Void {
    
    //        self.neutralParam = neutralParam
    
    //    }
    
    
    
    public func getImagesCollection() -> [FileInfo] {
        
        return imagesCollection
        
    }
    
    
    
    public func setImagesCollection(allreadyAdded : [FileInfo]) -> Void {
        
        if allreadyAdded.count > 0 {
            
            for i in 0..<allreadyAdded.count {
                
                let cloneFile = FileInfo()
                
                let originalFile = allreadyAdded[i]
                
                
                
                if originalFile.getFileTag() != nil {
                    
                    cloneFile.setFileTag(fileTag: ImageTagModel(tagId : (originalFile.getFileTag()?.getTagId())!,tagName : originalFile.getFileTag()!.getTagName(), mandatory : (originalFile.getFileTag()?.isMandatory())!, noOfPhotos : (originalFile.getFileTag()?.getNumberOfPhotos())!))
                    
                    
                    
                    cloneFile.setSelected(selected: originalFile.getSelected());
                    
                    cloneFile.setSource(source: originalFile.getSource());
                    
                    cloneFile.setFileName(fileName: originalFile.getFileName());
                    
                    cloneFile.setDateTimeTaken(dateTimeTaken: originalFile.getDateTimeTaken());
                    
                    cloneFile.setDisplayName(displayName: originalFile.getDisplayName());
                    
                    cloneFile.setFileCount(fileCount: originalFile.getFileCount());
                    
                    cloneFile.setFilePath(filePath: originalFile.getFilePath() ?? "");
                    
                    cloneFile.setType(type: originalFile.getType());
                    
                    imagesCollection.append(cloneFile)
                    
                }
                
            }
            
        }
        
    }
    
    
    
    public func checkImagesAvailableForTag(tagModel : ImageTagModel) -> Bool {
        
        if imagesCollection.count <= 0 {
            
            return false;
            
        }
        
        for i in 0..<imagesCollection.count {
            
            if imagesCollection[i].getFileTag() != nil && imagesCollection[i].getFileTag()?.getTagId() == tagModel.getTagId() &&
                
                imagesCollection[i].getFileTag()?.getTagName() == tagModel.getTagName() {
                
                return true;
                
            }
            
        }
        
        return false
        
    }
    
    
    
    public func checkImageAvailableForPath(fileInfo : FileInfo) -> Bool {
        
        if imagesCollection.count <= 0 {
            
            return false;
            
        }
        
        for i in 0..<imagesCollection.count {
            
            if imagesCollection[i].getFilePath()!.lowercased() == fileInfo.getFilePath()!.lowercased() {
                
                return true;
                
            }
            
        }
        
        return false;
        
    }
    
    
    
    public func removeFromCollection(fileInfo : FileInfo) -> Bool {
        
        if imagesCollection.count <= 0 {
            
            return true;
            
        }
        
        for i in 0..<imagesCollection.count {
            
            if imagesCollection[i].getFilePath() == fileInfo.getFilePath() {
                
                return imagesCollection.remove(at: i) != nil
                
            }
            
        }
        
        return true;
        
    }
    
    
    
}
