//
//  SlideShowTableViewCell.swift
//  ToddlerPicViewer
//
//  Created by Robert on 20/04/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var nameLabel: UILabel!    
    @IBOutlet weak var currentImage: UIImageView!
    
    var id : String = ""
}
