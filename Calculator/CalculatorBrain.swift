//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by macbook on 11/22/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    var resultIsPending: Bool = false
    
    private var description: String = ""
    
    private enum Operation {
        case constant(Double)
        case random
        case backspace
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        // added
        "sin" : Operation.unaryOperation(sin),
        "tan" : Operation.unaryOperation(tan),
        "1/x" : Operation.unaryOperation({ 1 / $0 }), //closure
        "x^2" : Operation.unaryOperation({ $0 * $0 }), //closure
        "x^3" : Operation.unaryOperation({ $0 * $0 * $0 }), //closure
        "x^y" : Operation.binaryOperation(pow), // closure
        "e^x" : Operation.unaryOperation({ pow(M_E, $0) }), //closure
        "10^x" : Operation.unaryOperation({ pow(10.0, $0) }), //closure
        "ln" : Operation.unaryOperation({ log($0) }), //closure
        "sinh" : Operation.unaryOperation(sinh),
        "Rnd" : Operation.random,
        "⇐" : Operation.backspace,
        "∛" : Operation.unaryOperation({ pow($0, 0.33333) }), //closure
        // from lecture
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E), // was added on lecture but no button created
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({ -$0 }), //closure
        "×" : Operation.binaryOperation({ $0 * $1 }), // closure
        "÷" : Operation.binaryOperation({ $0 / $1 }), //closure
        "-" : Operation.binaryOperation({ $0 - $1 }), //closure
        "+" : Operation.binaryOperation({ $0 + $1 }), //closure
        "=" : Operation.equals
    ]
    // in closure everything before "in" acts as argument, after "in" as a function contents
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                
                description.append(symbol)
                
                resultIsPending = false
                accumulator = value
            case .random:
                let value = Double(arc4random()) / Double(UInt32.max)
                description.append(numberFormatter(String(value)))
                accumulator = value
            case .backspace:
                if accumulator != nil {
                    let stringAccumulator = numberFormatter(String(accumulator!))
                    accumulator = Double(stringAccumulator.dropLast())
                    print(stringAccumulator.dropLast())
                } else {
                    accumulator = 0
                    description = "0"
                }
            case .unaryOperation(let function):
                if accumulator != nil {
                    
                    if resultIsPending {
                        description.append(symbol + "(" + numberFormatter(String(accumulator!)) + ")")
                    } else {
                        description = symbol + "(" + String(description) + ")"
                    }
                    
                    resultIsPending = false
                    
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    
                    description.append(symbol)
                    
                    resultIsPending = true
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil // I am in a weird "half-state", so set accumulator to nil
                }
            case .equals:
                
                if resultIsPending {
                    print("pending")
                    description.append(numberFormatter(String(accumulator!)))
                } else {
                    print("not pending")
                }
                
                resultIsPending = false
                performPendingBinaryOperation()
            }
        }
    }
    
    // finishing up the pending state
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    // needed for cases when we are in the middle of binary operation
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        
        if !resultIsPending {
            description = numberFormatter(String(operand))
        }
        
        accumulator = operand
    }
    
    // read only property, only get, no set
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    // read only property, only get, no set
    var sequence: String? {
        get {
            return description
        }
    }
    
    func numberFormatter(_ value: String?) -> String {
        guard value != nil else { return "0.00" }
        let doubleValue = Double(value!) ?? 0.0
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        
        return formatter.string(from: NSNumber(value: doubleValue)) ?? "\(doubleValue)"
    }
    
}

