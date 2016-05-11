//
//  SlideShows.swift
//  ToddlerPicViewer
//
//  Created by Win8 Jayway on 23/04/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class SlideShowsModel {
    private  var slideShows: [SlideShowModel]?

    func getSlideShows() -> [SlideShowModel] {
        if (slideShows == nil) {
            if let savedSlideShows = loadSlideShows() {
                slideShows = []
                slideShows! += savedSlideShows
            }
            
            if (slideShows == nil) {
                slideShows = []
                // No data has ever been created, add sample data
                // Not working, image not saved to disk
//                let slideShow1 = SlideShowModel(name: "exempel 1", cards: [CardModel]())
//                let imageView = UIImageView.init()
//                let photo = UIImage(named: "toycar.jpeg")
//                imageView.image = photo
//                let card = CardModel(text: "bil", photo: imageView.image!)
//                slideShow1.saveCard(card)
//                let slideShow2 = SlideShowModel(name: "exempel 2", cards: [CardModel]())
//                
//                slideShows! += [slideShow1, slideShow2]
            }

        }
        
        return slideShows!
    }
    
    func getSlideShowFromId(id: String) -> SlideShowModel? {
        if (slideShows == nil) {
            return nil
        }
        
        for slideShow in slideShows! {
            if (id == slideShow.id) {
                return slideShow
            }
        }
        return nil
    }

    func saveSlideShow(newSlideShow: SlideShowModel) {
        if (slideShows == nil) {
            return
        }

        let oldSlideShow = getSlideShowFromId(newSlideShow.id)
        if (oldSlideShow == nil) {
            slideShows!.append(newSlideShow)
        }
    }
    
    func deleteSlideShow(index: Int) {
        if (slideShows == nil) {
            return
        }

        if (index < 0 || index > slideShows!.count - 1) {
            return
        }
        
        slideShows!.removeAtIndex(index)
    }
    
    func saveCardToSlideShow(newSlideShow: SlideShowModel, newCard: CardModel) {
        let oldSlideShow = getSlideShowFromId(newSlideShow.id)
        if (oldSlideShow == nil) {
            slideShows!.append(newSlideShow)
        }
        newSlideShow.saveCard(newCard)
    }
    
    
    func saveToDisk() {
        if (slideShows == nil) {
            return
        }

        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(slideShows!, toFile: SlideShowModel.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save slideShows...")
        }
    }
    
    func loadSlideShows() -> [SlideShowModel]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(SlideShowModel.ArchiveURL.path!) as? [SlideShowModel]
    }
}
