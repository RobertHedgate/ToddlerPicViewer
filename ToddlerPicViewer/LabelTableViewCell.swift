//
//  Label.swift
//  ToddlerPicViewer
//
//  Created by Robert on 23/04/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

typealias EditEndHandler = (LabelTableViewCell) -> Void

class LabelTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var nameLabel: UITextField!
    
    var nameLabelEditEndHandler: EditEndHandler?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.delegate = self
    }
    
    @IBAction func nameLabelEditEnd(sender: UITextField) {
        nameLabelEditEndHandler?(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
