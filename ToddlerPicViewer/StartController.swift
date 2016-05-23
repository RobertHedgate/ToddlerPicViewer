//
//  StartController.swift
//  ToddlerPicViewer
//
//  Created by Robert on 19/04/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class StartController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
 
    override func viewDidAppear(animated: Bool) {
        // update tableview on UI thread when view is displayed
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
            // this is the empty text cell which will show if there are no slideshows
            return 1
        }
        
        return slideShows.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let slideShows = AppDelegate.slideShowsModel.getSlideShows()
        
        if (slideShows.count == 0) {
            // if no slideshows return the empty text
            let cellIdentifier = "StartLabelTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StartLabelTableViewCell
            return cell
        }
        
        let cellIdentifier = "StartTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StartTableViewCell
        
        let slideShow = slideShows[indexPath.row]
        
        if (slideShow.name != "") {
            cell.nameLabel.text = slideShow.name
            cell.nameLabel.textColor = UIColor.blackColor()
        }
        else {
            cell.nameLabel.textColor = UIColor.grayColor()
            cell.nameLabel.text = "<inget namn angivet>"
        }
        cell.id = slideShow.id
        if (slideShow.cards.count > 0) {
            cell.photoImageView.image = slideShow.cards[0].photo ?? UIImage(named: "noimage2")
        }
        else {
            cell.photoImageView.image = UIImage(named: "noimage2")
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // don´t want any cell to be selected
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "SlideShowSegue") {
            // pass data to next view
            let viewController:SlideShowController = segue.destinationViewController as! SlideShowController
            let sourceController:StartTableViewCell = sender as! StartTableViewCell
            viewController.id = sourceController.id
        }
    }

}

