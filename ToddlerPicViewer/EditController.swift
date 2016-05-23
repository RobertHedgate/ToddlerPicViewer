//
//  EditController.swift
//  ToddlerPicViewer
//
//  Created by Robert on 20/04/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class EditController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // remove AdultTestController from navstack since we want to go back to start
        self.navigationController?.viewControllers.removeAtIndex(1)
     }
    
    override func viewDidAppear(animated: Bool) {
        // update tableview on UI thread when view appears
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let slideShows = AppDelegate.slideShowsModel.getSlideShows()
        if (slideShows.count == 0) {
            // Empty text cell if there are no slideshows
            return 1
        }
        return slideShows.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let slideShows = AppDelegate.slideShowsModel.getSlideShows()
        if (slideShows.count == 0) {
            // empty text cell
            let cellIdentifier = "EditLabelTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            return cell
        }
        let cellIdentifier = "EditTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EditTableViewCell
        
        let slideShow = slideShows[indexPath.row]
        
        if (slideShow.name != "") {
            cell.nameLabel.text = slideShow.name
            cell.nameLabel.textColor = UIColor.blackColor()
        }
        else {
            cell.nameLabel.textColor = UIColor.grayColor()
            cell.nameLabel.text = "<inget namn angivet>"
        }
        if (slideShow.cards.count > 0) {
            cell.currentImage.image = slideShow.cards[0].photo ?? UIImage(named: "noimage2")
        }
        else {
            cell.currentImage.image = UIImage(named: "noimage2")
        }
        cell.id = slideShow.id
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // don´t want any cell to stay selected
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let slideShows = AppDelegate.slideShowsModel.getSlideShows()
        if (slideShows.count == 0) {
            // can´t remove emoty text cell
            return false
        }
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Ta bort", handler: deleteAskHandler)
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
    }

    func deleteAskHandler(alert: UITableViewRowAction!, indexPath: NSIndexPath) {
        // Make sure question before delete
        let alertController = UIAlertController(title: "Ta bort", message: "Är du säker på att du vill ta bort hela bildserien?", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            AppDelegate.slideShowsModel.deleteSlideShow(indexPath.row)
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
            let viewController:EditSlideShowController = segue.destinationViewController as! EditSlideShowController
            let sourceController:EditTableViewCell = sender as! EditTableViewCell
            viewController.id = sourceController.id
        }

    }
    
}