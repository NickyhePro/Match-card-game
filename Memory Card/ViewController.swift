//
//  ViewController.swift
//  Memory Card
//
//  Created by Nick He on 21/01/19.
//  Copyright © 2019 Nick He. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    // Declare Outlets
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    
    // Declare instance variables
    
    let bgImage : UIImage = #imageLiteral(resourceName: "card_bg")
    var cardCollection: [UIImage] = [#imageLiteral(resourceName: "colour2"), #imageLiteral(resourceName: "colour2"), #imageLiteral(resourceName: "colour3"), #imageLiteral(resourceName: "colour3"), #imageLiteral(resourceName: "colour8"), #imageLiteral(resourceName: "colour8"), #imageLiteral(resourceName: "colour5"), #imageLiteral(resourceName: "colour5"), #imageLiteral(resourceName: "colour1"), #imageLiteral(resourceName: "colour1"), #imageLiteral(resourceName: "colour4"), #imageLiteral(resourceName: "colour4"), #imageLiteral(resourceName: "colour7"), #imageLiteral(resourceName: "colour7"), #imageLiteral(resourceName: "colour6"), #imageLiteral(resourceName: "colour6")]
    var numOfSelectedCards = 0
    var firstSelectedCard : UIButton?
    var score = 0
    var numOfCorrection = 0
    var ref: DatabaseReference!
    var highestScore = -100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardCollection.shuffle()
    
        retrieveUserScore()
    
    }
    
    // TODO: Retrieve user score from Firebase
    
    func retrieveUserScore() {
        ref = Database.database().reference()
        ref.child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.highestScore = value?["highestScore"] as? Int ?? -100
            self.recordLabel.text = "Record: \(self.highestScore)"
            print("Highest score: \(self.highestScore)")
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //TODO: Disable auto rotation
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    //TODO: Set button click event
    
    @IBAction func btnPressed(_ sender: UIButton) {
        
        if sender.backgroundImage(for: .normal) == bgImage && numOfSelectedCards < 2{
            
            let tag = sender.tag
            
            sender.setBackgroundImage(cardCollection[tag], for: .normal)
            
            filpCards(card: sender)
            
            numOfSelectedCards += 1
            
            if numOfSelectedCards == 1 {
                
                firstSelectedCard = sender
                
            } else if numOfSelectedCards == 2 {
                
                if firstSelectedCard?.backgroundImage(for: .normal) != cardCollection[tag] {
                    
                    score -= 1
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        // Reset cards to bgImage and flip them back
                        self.firstSelectedCard?.setBackgroundImage(self.bgImage, for: .normal)
                        sender.setBackgroundImage(self.bgImage, for: .normal)
                        
                        self.filpCards(card: self.firstSelectedCard!)
                        self.filpCards(card: sender)
                        
                        self.numOfSelectedCards = 0
                    }
                    
                } else {
                    score += 2
                    numOfCorrection += 2
                    numOfSelectedCards = 0
                }
                
                scoreLabel.text = "\(score)"
                
                if numOfCorrection == 16 {
                    onGameFinishes()
                }
            }
        }
        
    }
    
    
    //TODO: Do if game finishes
    
    func onGameFinishes() {
        if score > highestScore {
            performSegue(withIdentifier: "openPopupWindow", sender: self)
        } else {
            performSegue(withIdentifier: "goToResultScreen", sender: self)
        }
    }
    
    //TODO: Passing data bewteen segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "openPopupWindow" {
            
            let destinationVC = segue.destination as! PopupWindow
            
            destinationVC.score = self.score
        } else if segue.identifier == "goToResultScreen" {
            
            let destinationVC = segue.destination as! ResultPopupWindow
            
            destinationVC.score = self.score
        }
    }
    
    //TODO: Flip the card method
    
    func filpCards(card: UIButton) {
        UIView.transition(with: card, duration: 0.4, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    
}

