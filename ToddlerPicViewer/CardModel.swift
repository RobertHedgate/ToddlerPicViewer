//
//  Card.swift
//  ToddlerPicViewer
//
//  Created by Robert on 20/04/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit
import Foundation

class CardModel: NSObject, NSCoding {
    var text = ""
    var photo: UIImage?
    var id: String
    
    init(text: String, photo: UIImage?) {
        self.text = text
        self.photo = photo
        self.id = NSUUID().UUIDString
       
        super.init()
    }
    
    // MARK: NSCoding
    struct PropertyKey {
        static let textKey = "name"
        static let photoKey = "photo"
        static let idKey = "id"
    }
    
    required init(coder aDecoder: NSCoder) {
        self.text = aDecoder.decodeObjectForKey(PropertyKey.textKey) as! String
        self.photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        self.id = aDecoder.decodeObjectForKey(PropertyKey.idKey) as! String
   }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.text, forKey: PropertyKey.textKey)
        aCoder.encodeObject(self.photo, forKey: PropertyKey.photoKey)
        aCoder.encodeObject(self.id, forKey: PropertyKey.idKey)
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("cards")
}
