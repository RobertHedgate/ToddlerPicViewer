//
//  Label.swift
//  ToddlerPicViewer
//
//  Created by Robert on 23/04/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

typealias EditEndHandler = (LabelTableViewCell) -> Void

class LabelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UITextField!
    
    var nameLabelEditEndHandler: EditEndHandler?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func nameLabelEditEnd(sender: UITextField) {
        nameLabelEditEndHandler?(self)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
