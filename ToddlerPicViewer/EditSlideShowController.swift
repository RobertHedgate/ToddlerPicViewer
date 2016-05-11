//
//  EditSlideShow.swift
//  ToddlerPicViewer
//
//  Created by Win8 Jayway on 23/04/16.
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
        if (id != "") {
            self.title = "Edit slideshow"
            slideShowModel = AppDelegate.slideShowsModel.getSlideShowFromId(id)
            self.name = (slideShowModel?.name)!
        }
        else {
            slideShowModel = SlideShowModel.init(name: "", cards: [CardModel]())
        }
    }

    override func viewWillDisappear(animated: Bool) {
        slideShowModel?.name = (labelCell?.nameLabel.text)!
        AppDelegate.slideShowsModel.saveSlideShow(slideShowModel!)
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + (slideShowModel?.cards.count)!
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
        else if (indexPath.row == tableView.numberOfRowsInSection(0) - 1) {
            let cellIdentifier = "NewImageCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ButtonTableViewCell
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
            cell.displayLabel.text = "<ingen text angiven>"
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
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // let the controller to know that able to edit tableView's row
        if (indexPath.row == 0 || indexPath.row == tableView.numberOfRowsInSection(0) - 1) {
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
        let deleteAction = UITableViewRowAction(style: .Default, title: "Ta bort", handler: deleteAskHandler)
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
    }
    
    func deleteAskHandler(alert: UITableViewRowAction!, indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: "Ta bort", message: "Är du säker på att du vill ta bort denna bild?", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.slideShowModel!.deleteCard(indexPath.row - 1)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        })
        let cancelAction = UIAlertAction(title: "Avbryt", style: .Default, handler: nil)
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
            let viewController:NewSlideShowImageController = segue.destinationViewController as! NewSlideShowImageController
            viewController.slideShowId = (self.slideShowModel?.id)!
            let card = sender as! SlideShowImageTableViewCell
            viewController.cardId = card.id
        }
    }
}
