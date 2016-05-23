//
//  AdultTestController.swift
//  ToddlerPicViewer
//
//  Created by Robert on 13/05/16.
//  Copyright © 2016 Robert. All rights reserved.
//

import UIKit

class AdultTestController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerText: UITextField!
    
    var answer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        answerText.delegate = self
        
        let i = Int(arc4random_uniform(10)) + 1
        let j = Int(arc4random_uniform(10)) + 1
        answer = i + j
        questionLabel.text = NSLocalizedString("Vad är ", comment: "What is ") + i.description + " + " + j.description
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        answerText.resignFirstResponder()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "AdultTestSegue") {
            if (answerText.text == answer.description) {
                answerText.text = ""
                return true
            }
        }
        answerText.text = ""
        return false
    }

}