//
//  setGame.swift
//  SetGame
//
//  Created by macbook on 9/23/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import Foundation

class setGame
{
    var deck = setCardDeck()
    
    var cards = [setCard]()
    
    var setSuccess = false
    
    var score = 0
    
    var indexOfOneFaceUpCard: Int? // If optional is not set the function does not need to do any work
    var indexOfAnotherFaceUpCard: Int? // If optional is not set the function does not need to do any work
    
    
    // Logic of the game of Concentration
    func printCardID(passedID: Int){
        print(passedID)
        print(cards[passedID])
    }
    
    func chooseCards(at index: Int) {
        // Case 1: No cars are face up
        // Case 2: 1 card is face up
        // Case 3: 2 cards are face up
        // Case 4: 3 cards are face up
        // a) Set
        // b) Not set
        
        // Checking if the card is in the game
        let isIndexValid = cards.indices.contains(index)
        
        if isIndexValid {
            // Deselection logic
            if cards[index].isSelected == true, indexOfOneFaceUpCard != nil, indexOfAnotherFaceUpCard == nil {
                // If the first card was deselected
                cards[index].isSelected = false
                indexOfOneFaceUpCard = nil
                score -= 1
            } else if cards[index].isSelected == true, indexOfAnotherFaceUpCard != nil {
                // If the second card was deselected
                cards[index].isSelected = false
                indexOfAnotherFaceUpCard = nil
                score -= 1
            } else {
                // If the card was not selected go further
                if !cards[index].isSet {
                    // Check is cards set
                    if let oneSetIndex = indexOfOneFaceUpCard, let anotherSetIndex = indexOfAnotherFaceUpCard, oneSetIndex != index, anotherSetIndex != index {
                        // check if cards match
                        var sameFeatures = 0
                        var differentFeatures = 0
                        
                        let colorSum = (cards[oneSetIndex].color.rawValue + cards[anotherSetIndex].color.rawValue + cards[index].color.rawValue)
                        
                        let shapeSum = (cards[oneSetIndex].shape.rawValue + cards[anotherSetIndex].shape.rawValue + cards[index].shape.rawValue)
                        
                        let shadeSum = (cards[oneSetIndex].shade.rawValue + cards[anotherSetIndex].shade.rawValue + cards[index].shade.rawValue)
                        
                        let numberOfShapesSum = (cards[oneSetIndex].numberOfShapes.rawValue + cards[anotherSetIndex].numberOfShapes.rawValue + cards[index].numberOfShapes.rawValue)
                        
                        // Checking different and same features
                        if colorSum / 3 == cards[oneSetIndex].color.rawValue, colorSum / 3 == cards[anotherSetIndex].color.rawValue, colorSum / 3 == cards[index].color.rawValue {
                            sameFeatures += 1
                        } else if colorSum == 3, cards[oneSetIndex].color != cards[index].color, cards[anotherSetIndex].color != cards[index].color, cards[oneSetIndex].color != cards[anotherSetIndex].color {
                            differentFeatures += 1
                        }
                        
                        if shapeSum / 3 == cards[oneSetIndex].shape.rawValue, shapeSum / 3 == cards[anotherSetIndex].shape.rawValue, shapeSum / 3 == cards[index].shape.rawValue {
                            sameFeatures += 1
                        } else if shapeSum == 3, cards[oneSetIndex].shape != cards[index].shape, cards[anotherSetIndex].shape != cards[index].shape, cards[oneSetIndex].shape != cards[anotherSetIndex].shape {
                            differentFeatures += 1
                        }
                        
                        if shadeSum / 3 == cards[oneSetIndex].shade.rawValue, shadeSum / 3 == cards[anotherSetIndex].shade.rawValue, shadeSum / 3 == cards[index].shade.rawValue {
                            sameFeatures += 1
                        } else if shadeSum == 3, cards[oneSetIndex].shade != cards[index].shade, cards[anotherSetIndex].shade != cards[index].shade, cards[oneSetIndex].shade != cards[anotherSetIndex].shade {
                            differentFeatures += 1
                        }
                        
                        if numberOfShapesSum / 3 == cards[oneSetIndex].numberOfShapes.rawValue, numberOfShapesSum / 3 == cards[anotherSetIndex].numberOfShapes.rawValue, numberOfShapesSum / 3 == cards[index].numberOfShapes.rawValue {
                            sameFeatures += 1
                        } else if numberOfShapesSum == 3, cards[oneSetIndex].numberOfShapes != cards[index].numberOfShapes, cards[anotherSetIndex].numberOfShapes != cards[index].numberOfShapes, cards[oneSetIndex].numberOfShapes != cards[anotherSetIndex].numberOfShapes {
                            differentFeatures += 1
                        }
                        
                        if (sameFeatures + differentFeatures) == 4 {
                            cards[oneSetIndex].isSet = true
                            cards[anotherSetIndex].isSet = true
                            cards[index].isSet = true
                            setSuccess = true
                            score += 3
                        } else {
                            setSuccess = false
                            score -= 5
                        }
                        cards[index].isSelected = true
                        indexOfOneFaceUpCard = nil
                        indexOfAnotherFaceUpCard = nil
                    } else if let oneSetIndex = indexOfOneFaceUpCard, oneSetIndex != index {
                        // If one card is face up
                        cards[index].isSelected = true
                        indexOfAnotherFaceUpCard = index
                    } else {
                        // Either no cards or three cards are faced up
                        // Go through all cards to flip them down
                        for flipDownIndex in cards.indices {
                            cards[flipDownIndex].isSelected = false
                        }
                        cards[index].isSelected = true
                        indexOfOneFaceUpCard = index
                    }
                }
            }
        } else {
            print("This card is not in the game")
        }
    }
    
    func addCard(){
        for _ in 0..<3 {
            if let card = deck.draw(){
                //print("Adding extra card \(card)")
                cards += [card]
            } else {
                print("No more cards to deal")
            }
        }
    }
    
    init(numberOfCards: Int) {
        deck = setCardDeck()
        print(deck.cards.count)
        for _ in 0..<numberOfCards {
            if let card = deck.draw(){
                cards += [card]
            }
        }
    }
}
