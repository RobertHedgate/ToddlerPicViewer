//
//  SlideShowController.swift
//  ToddlerPicViewer
//
//  Created by Robert on 22/04/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class SlideShowController: UIViewController {

    var id: String = ""
    var currentIndex = 0
    var slideShowModel: SlideShowModel?
    
    @IBOutlet weak var currentImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SlideShowController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SlideShowController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        slideShowModel = AppDelegate.slideShowsModel.getSlideShowFromId(id)
        self.title = slideShowModel?.name
        
        showCard()
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.Right:
                    currentIndex = currentIndex - 1
                case UISwipeGestureRecognizerDirection.Left:
                    currentIndex = currentIndex + 1
                default:
                    break
            }
            showCard()
        }
    }
    
    func showCard() {
        if (slideShowModel == nil || slideShowModel?.cards.count == 0) {
            textLabel.text = ""
            currentImageView.image = nil
            return
        }
        
        if (currentIndex >= slideShowModel?.cards.count) {
            currentIndex = 0
        }
        if (currentIndex < 0) {
            currentIndex = (slideShowModel?.cards.count)! - 1
        }
        
        if (slideShowModel?.cards.count > currentIndex) {
            currentImageView.image = slideShowModel?.cards[currentIndex].photo ?? UIImage(named: "noimage2")
            textLabel.text = slideShowModel?.cards[currentIndex].text
        }
    }
}
