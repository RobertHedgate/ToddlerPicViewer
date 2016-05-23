//
//  EditSlideShow.swift
//  ToddlerPicViewer
//
//  Created by Robert on 23/04/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class EditSlideShowController: UITableViewController {

    var name = ""
    var id = ""
    var slideShowModel : SlideShowModel? = nil
    var labelCell: LabelTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if id is empty this is a new slideshow
        if (id != "") {
            self.title = NSLocalizedString("Ändra bildserie", comment: "Edit slideshow")
            slideShowModel = AppDelegate.slideShowsModel.getSlideShowFromId(id)
            self.name = (slideShowModel?.name)!
        }
        else {
            slideShowModel = SlideShowModel.init(name: "", cards: [CardModel]())
        }
    }

    override func viewWillDisappear(animated: Bool) {
        // update data when leaving view
        slideShowModel?.name = (labelCell?.nameLabel.text)!
        AppDelegate.slideShowsModel.addSlideShow(slideShowModel!)
    }
    
    override func viewDidAppear(animated: Bool) {
        // reload tableview when view has appeard
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (slideShowModel?.cards.count == 0) {
            // name plus empty text cell
            return 2
        }
        return 1 + (slideShowModel?.cards.count)! // name plus count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cellIdentifier = "LabelCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LabelTableViewCell
            cell.nameLabel.text = name
            cell.nameLabelEditEndHandler = nameLabelEditEndHandler()
            labelCell = cell
            return cell
        }
        
        if (slideShowModel?.cards.count == 0) {
            let cellIdentifier = "newSlideShowLabelCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            return cell
        }
        let cellIdentifier = "SlideShowImageCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SlideShowImageTableViewCell
        
        let card = slideShowModel?.cards[indexPath.row - 1]
        if (card!.text != "") {
            cell.displayLabel.text = card!.text
            cell.displayLabel.textColor = UIColor.blackColor()
        }
        else {
            cell.displayLabel.textColor = UIColor.grayColor()
            cell.displayLabel.text = NSLocalizedString("<ingen text angiven>", comment: "<No text is set>")
        }
        cell.photo.image = card!.photo ?? UIImage(named: "noimage2")
        cell.id = card!.id
        
        return cell
    }
    
    private func nameLabelEditEndHandler() -> EditEndHandler {
        return { [unowned self] cell in
            self.name = cell.nameLabel.text!
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! LabelTableViewCell
            name = cell.nameLabel.text!
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // don´t keep selection
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // let the controller to know that able to edit tableView's row
        if (indexPath.row == 0) {
            return false
        }
        if (slideShowModel?.cards.count == 0) {
            // if no cards return false, empty text cell
            return false
        }
        
        return true
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {// || indexPath.row == tableView.numberOfRowsInSection(0) - 1) {
            return 44.0
        }
        if (indexPath.row == (slideShowModel?.cards.count)! + 2 - 1) {
            return 44.0
        }
        
        return 100.0
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        let deleteAction = UITableViewRowAction(style: .Default, title: NSLocalizedString("Ta bort", comment: "Remove"), handler: deleteAskHandler)
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
    }
    
    func deleteAskHandler(alert: UITableViewRowAction!, indexPath: NSIndexPath) {
        // ask before delete
        let alertController = UIAlertController(title: NSLocalizedString("Ta bort", comment: "Remove"), message: NSLocalizedString("Är du säker på att du vill ta bort denna bild?", comment: "Are you sure you want to remove this image"), preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.slideShowModel!.deleteCard(indexPath.row - 1)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Avbryt", comment: "Cancel"), style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "SlideShowSegue") {
            // pass data to next view
            let viewController:NewSlideShowImageController = segue.destinationViewController as! NewSlideShowImageController
            viewController.slideShowId = (self.slideShowModel?.id)!
        }
        if (segue.identifier == "ExistingSlideShowSegue") {
            // pass data to next view
            let viewController:NewSlideShowImageController = segue.destinationViewController as! NewSlideShowImageController
            viewController.slideShowId = (self.slideShowModel?.id)!
            let card = sender as! SlideShowImageTableViewCell
            viewController.cardId = card.id
        }
    }
}
