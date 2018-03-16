//
//  File.swift
//  MatchApp
//
//  Created by Naval Jassi on 4/1/18.
//  Copyright © 2018 Naval Jassi. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        var generatedCardsArray = [Card]()
        
        for _ in 1...8 {
            let randomNumber = arc4random_uniform(13)+1
            
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            print(randomNumber)
            generatedCardsArray.append(cardOne)
            
            let cardTwo = Card()
            cardTwo.imageName = "card\(randomNumber)"
            
            generatedCardsArray.append(cardTwo)
            
        }
        
        return generatedCardsArray
    }
    
}
