//
//  NewSlideShowImage.swift
//  ToddlerPicViewer
//
//  Created by Robert on 03/05/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class NewSlideShowImageController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var slideShowId = ""
    var cardId = ""
    @IBOutlet weak var currentImage: UIImageView!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var displayText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        displayText.delegate = self
        
        if (cardId != "") {
            let slideShowModel = AppDelegate.slideShowsModel.getSlideShowFromId(self.slideShowId)
            let card = slideShowModel?.getCardFromId(cardId)
            currentImage.image = card?.photo ?? UIImage(named: "noimage2")
            displayText.text = card?.text
        }
        else {
            // default image
            currentImage.image = UIImage(named: "noimage2")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        // save data when leaving view
        var slideShowModel = AppDelegate.slideShowsModel.getSlideShowFromId(self.slideShowId)
        if (slideShowModel == nil) {
            // Should not get here!!!
            slideShowModel = SlideShowModel.init(name: "", cards: [CardModel]())
        }
        var cardModel = slideShowModel?.getCardFromId(cardId)
        if (cardModel == nil) {
            cardModel = CardModel.init(text: displayText.text!, photo: currentImage.image)
            cardId = cardModel!.id
            slideShowModel?.addCard(cardModel!)
        }
        else {
            cardModel?.text = displayText.text!
            cardModel?.photo = currentImage.image
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {        
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func takePicture(sender: UIButton) {
        // get picture from camera. Warning if not allowed
        if (UIImagePickerController.isSourceTypeAvailable(.Camera) && UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .Camera
            imagePicker.cameraCaptureMode = .Photo
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: NSLocalizedString("Fel", comment: "Error"), message: NSLocalizedString("Ingen kamera funnen eller tillstånd har ej givits", comment: "No camera found or permission not given"), preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func takePictureLibrary(sender: UIButton) {
        // get image from library. If not allowed iOS will show error
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
        // set selected image
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
        // set selected image
        self.currentImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
}