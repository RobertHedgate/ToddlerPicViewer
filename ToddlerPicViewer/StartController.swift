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
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let slideShows = AppDelegate.slideShowsModel.getSlideShows()
        return slideShows.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let slideShows = AppDelegate.slideShowsModel.getSlideShows()
        let cellIdentifier = "StartTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StartTableViewCell
        //let cellIdentifier = "cell"
        //let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        // Fetches the appropriate meal for the data source layout.
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
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let destination = storyboard.instantiateViewControllerWithIdentifier("SlideShowController") as! SlideShowController
        //navigationController?.pushViewController(destination, animated: true)
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

