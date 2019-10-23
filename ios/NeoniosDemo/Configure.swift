//
//  Configure.swift
//  Neon-Ios
//
//  Created by Girnar on 03/09/19.
//  Copyright © 2019 Girnar. All rights reserved.
//

import Foundation

class Configure: Codable {
    var libraryMode : LibraryMode?
    var numberOfPhotos: Int?
    var cameraFacing: String?
    var cameraOrientation : CameraOrientation?
    var cameraViewType : CameraType?
    var galleryViewType : GalleryType?
    var tagEnabled : Bool?
    var flashEnabled : FlashMode?
    var cameraSwitchingEnabled : Bool?
    var cameraToGallerySwitchEnabled : Bool?
    var enableFolderStructure : Bool?
    var galleryToCameraSwitchEnabled : Bool?
    var isRestrictedExtensionJpgPngEnabled : Bool?
    var enableImageEditing : Bool?
    var locationRestrictive : Bool?
    var  hideCameraButtonInNeutral : Bool?
    var hideGalleryButtonInNeutral : Bool?
    var  hasOnlyProfileTag : Bool?
    //    var profileTagName = nil
    //    var imageTagListJson = nil
    //    var alreadyAddedImagesJson = nil
    
    
    init() {
        
    }
    private enum CodingKeys : String, CodingKey {
        case cameraFacing = "cameraFacing"
        case libraryMode = "libraryMode"
        case numberOfPhotos = "numberOfPhotos"
        case cameraOrientation = "cameraOrientation"
        case cameraViewType = "cameraViewType"
        case galleryViewType = "galleryViewType"
        case tagEnabled = "tagEnabled"
        case flashEnabled = "flashEnabled"
        case cameraSwitchingEnabled = "cameraSwitchingEnabled"
        case cameraToGallerySwitchEnabled = "cameraToGallerySwitchEnabled"
        case enableFolderStructure = "enableFolderStructure"
        case galleryToCameraSwitchEnabled =  "galleryToCameraSwitchEnabled"
        case isRestrictedExtensionJpgPngEnabled = "isRestrictedExtensionJpgPngEnabled"
        case enableImageEditing = "enableImageEditing"
        case locationRestrictive = "locationRestrictive"
        case  hideCameraButtonInNeutral = "hideCameraButtonInNeutral"
        case hideGalleryButtonInNeutral = "hideGalleryButtonInNeutral"
        case  hasOnlyProfileTag =  "hasOnlyProfileTag"
    }
    
    required init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
      
        if let cameraFacing = try? container.decode(String.self, forKey: .cameraFacing) {
            self.cameraFacing = cameraFacing
        }
        if let libraryMode = try? container.decode(LibraryMode.self, forKey: .libraryMode) {
            self.libraryMode = libraryMode
        }
        if  let tagEnabled = try? container.decode(Bool.self, forKey: .tagEnabled) {
            self.tagEnabled = tagEnabled
        }
        if let numberOfPhotos = try? container.decode(Int.self, forKey: .numberOfPhotos) {
            self.numberOfPhotos = numberOfPhotos
        }
        if let cameraOrientation = try?  container.decode(CameraOrientation.self, forKey: .cameraOrientation){
            self.cameraOrientation = cameraOrientation
        }
        if let galleryViewType = try? container.decode(GalleryType.self, forKey: .galleryViewType){
            self.galleryViewType = galleryViewType
        }
        if let cameraViewType = try? container.decode(CameraType.self, forKey: .cameraViewType){
            self.cameraViewType = cameraViewType
        }
        if let flashEnabled = try? container.decode(FlashMode.self, forKey: .flashEnabled){
            self.flashEnabled = flashEnabled
        }
        if let cameraSwitchingEnabled = try? container.decode(Bool.self, forKey: .cameraSwitchingEnabled){
            self.cameraSwitchingEnabled = cameraSwitchingEnabled
        }
        if let cameraToGallerySwitchEnabled = try? container.decode(Bool.self, forKey: .cameraToGallerySwitchEnabled){
            self.cameraToGallerySwitchEnabled = cameraToGallerySwitchEnabled
        }
        if let enableFolderStructure = try? container.decode(Bool.self, forKey: .enableFolderStructure){
            self.enableFolderStructure = enableFolderStructure
        }
        if let galleryToCameraSwitchEnabled = try? container.decode(Bool.self, forKey: .galleryToCameraSwitchEnabled){
            self.galleryToCameraSwitchEnabled = galleryToCameraSwitchEnabled
        }
        if let isRestrictedExtensionJpgPngEnabled = try? container.decode(Bool.self, forKey: .isRestrictedExtensionJpgPngEnabled){
            self.isRestrictedExtensionJpgPngEnabled = isRestrictedExtensionJpgPngEnabled
        }
        if let enableImageEditing = try? container.decode(Bool.self, forKey: .enableImageEditing){
            self.enableImageEditing = enableImageEditing
        }
        if let locationRestrictive = try? container.decode(Bool.self, forKey: .locationRestrictive){
            self.locationRestrictive = locationRestrictive
        }
        if let hideCameraButtonInNeutral = try? container.decode(Bool.self, forKey: .hideCameraButtonInNeutral){
            self.hideCameraButtonInNeutral = hideCameraButtonInNeutral
        }
        if let hideGalleryButtonInNeutral = try? container.decode(Bool.self, forKey: .hideGalleryButtonInNeutral){
            self.hideGalleryButtonInNeutral = hideGalleryButtonInNeutral
        }
        if let hasOnlyProfileTag = try? container.decode(Bool.self, forKey: .hasOnlyProfileTag){
            self.hasOnlyProfileTag = hasOnlyProfileTag
        }

        
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}
