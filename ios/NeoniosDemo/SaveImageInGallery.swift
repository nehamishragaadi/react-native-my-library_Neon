//
//  SaveImageInGallery.swift
//  Neon-Ios
//
//  Created by Temp on 28/08/19.
//  Copyright © 2019 Girnar. All rights reserved.
//

import Foundation
import Photos


class SaveImageInGallery {
    
    static let sharedInstance = SaveImageInGallery()
    typealias CompletionHandler = (_ success:String) -> Void
    
    public func saveImage(image: UIImage, albumName: String, completion: @escaping (String?, Error?)->()) {
        if let album = self.findAlbum(albumName: albumName) {
            self.savePhotoInCustomFolderGallery(photo: image, toAlbum: album) { (success, error,filePath) in
                if error != nil {
                    completion(nil, error)
                    print(error as Any)
                    return
                }
                completion(filePath, nil)
                
            }
            return
        }
        self.createPhotoLibraryAlbum(albumName: albumName) { (album) in
            self.savePhotoInCustomFolderGallery(photo: image, toAlbum: album!) { (success, error, filePath) in
                if error != nil {
                    completion(nil,error )
                    return
                }
                completion(filePath, nil)
            }
        }
        
    }
    private func findAlbum(albumName: String) -> PHAssetCollection? {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let album = collections.firstObject {
            return album
        }
        return nil
    }
    
    private  func createPhotoLibraryAlbum(albumName: String, completionHandler: @escaping (PHAssetCollection?)->()) {
        var albumPlaceholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            // Request creating an album with parameter name
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            // Get a placeholder for the new album
            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }, completionHandler: { success, error in
            guard let placeholder = albumPlaceholder else {
                assert(false, "Album placeholder is nil")
                completionHandler(nil)
                return
            }
            
            let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
            guard let album = fetchResult.firstObject else {
                assert(false, "FetchResult has no PHAssetCollection")
                completionHandler(nil)
                return
            }
            if success {
                completionHandler(album)
            }
            else {
                print(error as Any)
                completionHandler(nil)
            }
        })
    }
    
    private func savePhotoInCustomFolderGallery(photo: UIImage, toAlbum album: PHAssetCollection, completionHandler: @escaping (Bool?, Error?, String?) -> ()) {
        
        var placeholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            // Request creating an asset from the image
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: photo)
            // Request editing the album
            guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) else {
                assert(false, "Album change request failed")
                return
            }
            // Get a placeholder for the new asset and add it to the album editing request
            guard let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else {
                assert(false, "Placeholder is nil")
                return
            }
            placeholder = photoPlaceholder
            albumChangeRequest.addAssets([photoPlaceholder] as NSFastEnumeration)
        }, completionHandler: { success, error in
            guard let placeholder = placeholder else {
                assert(false, "Placeholder is nil")
                completionHandler(nil, nil,nil)
                return
            }
            if success {
                let asset = PHAsset.fetchAssets(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                //                self.getImagePath(photoAssets: asset as! PHFetchResult<AnyObject>, completion: String)
                self.getImagePath(photoAssets: asset as! PHFetchResult<AnyObject>, completion: { (pathName) in
                    completionHandler(nil,nil,pathName)
                })
            }
            else {
                print(error as Any)
                completionHandler(nil, nil, nil)
            }
        })
    }
    func getImagePath(photoAssets: PHFetchResult<AnyObject>,completion: @escaping CompletionHandler) {
        
        
        //    func getImagePath(photoAssets: (PHFetchResult<AnyObject>), completion: (String) -> ()){
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isSynchronous = false
        
        photoAssets.enumerateObjects{(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                manager.requestImageData(for: object as! PHAsset, options: options,
                                         resultHandler: { (imagedata, dataUTI, orientation, info) in
                                            if let info = info {
                                                if info.keys.contains(NSString(string: "PHImageFileURLKey")) {
                                                    if let filePath = info[NSString(string: "PHImageFileURLKey")] as? URL {
                                                        print(filePath)
                                                        completion(filePath.absoluteString.replacingOccurrences(of: "file:///", with: ""))
                                                        
                                                    }
                                                }
                                            }
                })
            }
        }
    }
}
