//
//  setCardDeck.swift
//  setCardDrawing
//
//  Created by macbook on 10/10/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import Foundation

struct setCardDeck {
    private(set) var cards = [setCard]()
    
    init() {
        for shape in setCard.Shape.all {
            for shade in setCard.Shade.all{
                for color in setCard.Color.all{
                    for numberOfShapes in setCard.NumberOfShapes.all{
                        cards.append(setCard(isSet: false, isSelected: false, shape: shape, shade: shade, color: color, numberOfShapes: numberOfShapes))
                    }
                }
            }
        }
    }
    
    mutating func draw() -> setCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
}

