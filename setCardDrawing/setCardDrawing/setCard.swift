//
//  setCard.swift
//  setCardDrawing
//
//  Created by macbook on 10/10/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import Foundation

struct setCard: CustomStringConvertible {
    
    var description: String {
        return "shape: \(shape), shade: \(shade), color:\(color), Number of Shapes: \(numberOfShapes)"
    }
    
    var isSet = false
    var isSelected = false
    
    var shape: Shape
    var shade: Shade
    var color: Color
    var numberOfShapes: NumberOfShapes
    
    enum Shape: Int, CustomStringConvertible {
        case triangle = 0
        case square = 1
        case circle = 2
        
        static var all = [Shape.triangle, .square, .circle]
        
        var description: String {return "\(rawValue)"}
    }
    
    enum Shade: Int, CustomStringConvertible {
        case filled = 0
        case stripped = 1
        case outlined = 2
        
        static var all = [Shade.filled, .stripped, .outlined]
        
        var description: String {return "\(rawValue)"}
    }
    
    enum Color: Int, CustomStringConvertible {
        case red = 0
        case green = 1
        case purple = 2
        
        static var all = [Color.red, .green, .purple]
        
        var description: String {return "\(rawValue)"}
    }
    
    enum NumberOfShapes: Int, CustomStringConvertible {
        case one = 0
        case two = 1
        case three = 2
        
        static var all = [NumberOfShapes.one, .two, .three]
        
        var description: String {return "\(rawValue)"}
    }
    
    
}
