//
//  ViewController.swift
//  MatchApp
//
//  Created by Naval Jassi on 4/1/18.
//  Copyright © 2018 Naval Jassi. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlipCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 10 * 1000 // 10 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the get card method of the card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Creat timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Timer methods
    @objc func timerElapsed() {
        
        milliseconds -= 1
        
        // convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        // set label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // When the timer has reached 0 stop
        if milliseconds <= 0 {
            
            // stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // Check if there are any cards unmatched
            checkGameEnded()
        }
    }
    
    
    // MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Check if there is any time left
        if milliseconds <= 0 {
            return
        }
        
        // Get the cell that user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Get the card that user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false{
            
            // Flip the card
            cell.flip()
            
            // Set the status of the card
            card.isFlipped = true
            
            // Determine if it is the first card or the second card that's flipped over
            if firstFlipCardIndex == nil {
                
                // This is the first card being flipped
                firstFlipCardIndex = indexPath
            }
            else {
                // This is the second card being flipped
                
                // Perform the matching logic
                checkForMatches(indexPath)
            }
        }
        
    } // End of didSelectItem method
    
    // MARK: - Game Logic Methods
    
    func checkForMatches (_ secondFlipppeCardIndex:IndexPath) {
        
        // Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlipCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlipppeCardIndex) as? CardCollectionViewCell
        
        // Get the cards for the two cards that were revealed
        let cardOne = cardArray[firstFlipCardIndex!.row]
        let cardTwo = cardArray[secondFlipppeCardIndex.row]
        
        // Compair the two cards
        if cardOne.imageName == cardTwo.imageName {
            // It's a match
            
            // Set the statuses of the card
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if there are any cards left unmatched
            checkGameEnded()
        }
        else{
            // Its not a match
            
            // Set the status of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip both the cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        // Tell the collectionview to reload the cell of the card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlipCardIndex!])
        }
        
        firstFlipCardIndex = nil
        
    }
    
    func checkGameEnded() {
        
        // Determine if there are any cards unmatched.
        var isWon =  true
        
        for card in cardArray {
            
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        // Messaging variables
        
        var title = ""
        var message = ""
        
        // If not, user has won, stop the timer
        if isWon == true {
            
            if milliseconds > 0 {
                timer?.invalidate()
                
                title = "Congratulation"
                message = "You've won"
            }
        }
        else{
            // If there are unmatched cards, check if there is any time left
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You've lost"
        }
        
        // Show won/lost messages
        showAlert(title, message)
        
    }
    
    func showAlert(_ title:String, _ message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
        
        
    
} // End of viewControl class

