//
//  NewSlideShowImage.swift
//  ToddlerPicViewer
//
//  Created by Win8 Jayway on 03/05/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class NewSlideShowImageController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var slideShowId = ""
    var cardId = ""
    @IBOutlet weak var currentImage: UIImageView!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var displayText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        if (cardId != "") {
            let slideShowModel = AppDelegate.slideShowsModel.getSlideShowFromId(self.slideShowId)
            let card = slideShowModel?.getCardFromId(cardId)
            currentImage.image = card?.photo ?? UIImage(named: "noimage2")
            displayText.text = card?.text
        }
        else {
            currentImage.image = UIImage(named: "noimage2")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        var slideShowModel = AppDelegate.slideShowsModel.getSlideShowFromId(self.slideShowId)
        if (slideShowModel == nil) {
            // Should not get here!!!
            slideShowModel = SlideShowModel.init(name: "", cards: [CardModel]())
        }
        var cardModel = slideShowModel?.getCardFromId(cardId)
        if (cardModel == nil) {
            cardModel = CardModel.init(text: displayText.text!, photo: currentImage.image)
            cardId = cardModel!.id
            slideShowModel?.saveCard(cardModel!)
        }
        else {
            cardModel?.text = displayText.text!
            cardModel?.photo = currentImage.image
        }
    }
    
    @IBAction func SaveClicked(sender: UIBarButtonItem) {
        var slideShowModel = AppDelegate.slideShowsModel.getSlideShowFromId(self.slideShowId)
        if (slideShowModel == nil) {
            // Should not get here!!!
            slideShowModel = SlideShowModel.init(name: "", cards: [CardModel]())
        }
        var cardModel = slideShowModel?.getCardFromId(cardId)
        if (cardModel == nil) {
            cardModel = CardModel.init(text: displayText.text!, photo: currentImage.image!)
        }
        else {
            cardModel?.text = displayText.text!
            cardModel?.photo = currentImage.image!
        }
        
        slideShowModel?.saveCard(cardModel!)
        
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func takePicture(sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.Camera) && UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .Camera
            imagePicker.cameraCaptureMode = .Photo
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: "Fel", message: "Ingen kamera funnen eller tillstånd har ej givits", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func takePictureLibrary(sender: UIButton) {
        imagePicker.allowsEditing = false
        if (UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)) {
            imagePicker.sourceType = .PhotoLibrary
        }
        else if (UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum)) {
            imagePicker.sourceType = .SavedPhotosAlbum
        }
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.currentImage.contentMode = .ScaleAspectFit
            self.currentImage.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.currentImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
}