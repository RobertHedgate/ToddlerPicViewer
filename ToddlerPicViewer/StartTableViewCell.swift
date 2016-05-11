//
//  StartTableViewCell.swift
//  ToddlerPicViewer
//
//  Created by Win8 Jayway on 10/05/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class StartTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var id : String = ""
}