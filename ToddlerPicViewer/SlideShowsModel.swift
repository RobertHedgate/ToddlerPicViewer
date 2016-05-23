//
//  SlideShows.swift
//  ToddlerPicViewer
//
//  Created by Robert on 23/04/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

// Class for handling several slideshows
class SlideShowsModel {
    private  var slideShows: [SlideShowModel]?

    func getSlideShows() -> [SlideShowModel] {
        // Lazyload slideshows. If nil then load
        if (slideShows == nil) {
            if let savedSlideShows = loadSlideShows() {
                slideShows = []
                slideShows! += savedSlideShows
            }
            
            // if nil after load create an empty list
            if (slideShows == nil) {
                slideShows = []
            }
        }
        
        return slideShows!
    }
    
    func getSlideShowFromId(id: String) -> SlideShowModel? {
        if (slideShows == nil) {
            // should never happend but is here for just in case
            return nil
        }
        
        for slideShow in slideShows! {
            if (id == slideShow.id) {
                return slideShow
            }
        }
        return nil
    }

    func addSlideShow(newSlideShow: SlideShowModel) {
        if (slideShows == nil) {
            return
        }

        let oldSlideShow = getSlideShowFromId(newSlideShow.id)
        if (oldSlideShow == nil) {
            // only add if this is a new slideshow
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
