//
//  ImageTagModel.swift
//  Neon-Ios
//
//  Created by Girnar on 1/30/19.
//  Copyright © 2019 Girnar. All rights reserved.
//

import Foundation
import CoreLocation

public struct Coordinate: Codable {
    let latitude, longitude: String
}

public class ImageTagModel : Codable {
    private var tagId : String?
    private var tagName : String?
    private var mandatory : Bool?
    private var noOfPhotos : Int?
    private var isSelected : Bool?
    private var location : Coordinate?
    

    init(tagId : String,tagName : String, mandatory : Bool) {
        self.tagId = tagId
        self.tagName = tagName
        self.mandatory = mandatory
    }
    
    convenience init(tagId : String,tagName : String, mandatory : Bool, noOfPhotos : Int) {
        self.init(tagId: tagId, tagName: tagName, mandatory: mandatory)
        self.noOfPhotos = noOfPhotos

    }

    convenience init(tagId : String,tagName : String, mandatory : Bool, noOfPhotos : Int, location : Coordinate?, isSelected: Bool) {
        self.init(tagId: tagId, tagName: tagName, mandatory: mandatory)
        self.noOfPhotos = noOfPhotos
        self.location = location
        self.isSelected = isSelected
    }
    
    init() {
        
    }
    private enum CodingKeys: String, CodingKey {
        case tagId = "tagId"
        case tagName = "tagName"
        case mandatory = "mandatory"
        case noOfPhotos = "noOfPhotos"
        case isSelected = "isSelected"
         case location = "location"
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let tagId = try? container.decode(String.self, forKey: .tagId) {
            self.tagId = tagId
        }
        if let tagName = try? container.decode(String.self, forKey: .tagName) {
            self.tagName = tagName
        }
        if let mandatory = try? container.decode(Bool.self, forKey: .mandatory) {
            self.mandatory = mandatory
        }
        if let noOfPhotos = try? container.decode(Int.self, forKey: .noOfPhotos) {
            self.noOfPhotos = noOfPhotos
        }
        if let isSelected = try? container.decode(Bool.self, forKey: .isSelected) {
            self.isSelected = isSelected
        }
        if let location = try? container.decode(Coordinate.self, forKey: .location) {
            self.location = location
        }
    }
    public func encode(to encoder: Encoder) throws {
    }
    public func getTagName() -> String {
        return self.tagName ?? "NA"
    }

    public func isMandatory() -> Bool{
        return mandatory!
    }

    public func getTagId() -> String{
        return self.tagId ?? "0"
    }

    public func getNumberOfPhotos() -> Int{
        return noOfPhotos!
    }
    public func getloction() -> Coordinate? {
        return location
    }

    public func setIsSelected(isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    public func getIsSelected() -> Bool {
        return isSelected!
    }
}

extension CLLocationCoordinate2D {
    init(_ coordinate: Coordinate) {
        self.init(latitude: Double(coordinate.latitude)!, longitude: Double(coordinate.longitude)!)
    }
}

extension Coordinate {
    init(_ coordinate: CLLocationCoordinate2D) {
        self.init(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude))
    }
}
