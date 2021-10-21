//
//  Concentration.swift
//  Concentration
//
//  Created by macbook on 9/4/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import Foundation

struct Concentration
{
    
    private(set) var cards = [Card]()
    private(set) var flipCount = 0
    private(set) var scoreCount = 0
    private var seenCards = [Int]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    scoreCount += 2
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
            
            var flag = 0
            if seenCards.count == 0{
                seenCards.append(index)
            } else {
                for placeOfSeenCardNumber in seenCards{
                    if placeOfSeenCardNumber == index{
                        flag = 1
                        scoreCount -= 1
                    }
                }
                if flag == 0 {
                    seenCards.append(index)
                }
            }
        }
        
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(at: \(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards
        {
            let card = Card()
            cards += [card, card]
        }
        cards = cards.shuffled()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
