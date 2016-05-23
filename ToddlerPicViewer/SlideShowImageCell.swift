//
//  SlideShowImageCell.swift
//  ToddlerPicViewer
//
//  Created by Robert on 23/04/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class SlideShowImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    var id = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.photo.contentMode = .ScaleAspectFit
    }
    }