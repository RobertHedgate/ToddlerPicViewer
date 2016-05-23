//
//  SlideShow.swift
//  ToddlerPicViewer
//
//  Created by Robert on 20/04/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import Foundation

// Class for handling one slideshow
class SlideShowModel: NSObject, NSCoding {
    var name: String
    var cards: [CardModel]
    var id: String
    
    init(name: String, cards: [CardModel]) {
        self.name = name
        self.cards = cards
        self.id = NSUUID().UUIDString
    }
    
    func addCard(newCard: CardModel) {
        self.cards.append(newCard)
    }
    
    func getCardFromId(id: String) -> CardModel? {
        for card in cards {
            if (id == card.id) {
                return card
            }
        }
        return nil
    }
    
    func deleteCard(index: Int) {
        // check if index is in range
        if (index < 0 || index > cards.count - 1) {
            return
        }
        
        cards.removeAtIndex(index)
    }
    
    // MARK: NSCoding
    struct PropertyKey {
        static let nameKey = "name"
        static let cardsKey = "photo"
        static let idKey = "id"
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        self.cards = aDecoder.decodeObjectForKey(PropertyKey.cardsKey) as! [CardModel]
        self.id = aDecoder.decodeObjectForKey(PropertyKey.idKey) as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(self.cards, forKey: PropertyKey.cardsKey)
        aCoder.encodeObject(self.id, forKey: PropertyKey.idKey)
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("slideShow")
}
