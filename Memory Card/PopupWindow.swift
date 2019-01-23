//
//  PopupWindow.swift
//  Memory Card
//
//  Created by Nick He on 21/01/19.
//  Copyright © 2019 Nick He. All rights reserved.
//

import UIKit
import Firebase

class PopupWindow: UIViewController {

    // IBOutlets
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var popupView: UIView!
    
    // Instance variables
    
    var score: Int = -100
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 10
        
        ref = Database.database().reference()
        
        label.text = "Congrats! Your new score is \(score)!"
    }
    
    // Disable auto rotation
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    // Button click event
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        ref.child("user").setValue(["username": usernameTextField.text!, "highestScore": score])
        
        performSegue(withIdentifier: "goBackToViewController", sender: self)

    }
    
}
