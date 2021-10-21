//
//  Card.swift
//  Concentration
//
//  Created by macbook on 9/4/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import Foundation
// Difference between Struct and Class
// 1) Structs do not have inheritence
// 2) Structs are value types, Classes are reference types
// Structs = arrays, Ints, dictionaries, passing = copying
// copy-on-write semantics
// Clasees passing = pointers
struct Card: Hashable
{
    //var hashValue: Int { return identifier }

    func hash(into hasher: inout Hasher)  {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
        
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
