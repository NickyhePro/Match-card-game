//
//  ResultPopupWindow.swift
//  Memory Card
//
//  Created by Nick He on 21/01/19.
//  Copyright © 2019 Nick He. All rights reserved.
//

import UIKit

class ResultPopupWindow: UIViewController {

    // Declare Outlets
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var resultView: UIView!
    
    // Instances variables
    
    var score : Int = -100
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultView.layer.cornerRadius = 10
        
        label.text = "Your score is \(score)"
    }

    // Disable auto rotation
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    // Button click event
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goBackToViewController", sender: self)
    }
    
}
