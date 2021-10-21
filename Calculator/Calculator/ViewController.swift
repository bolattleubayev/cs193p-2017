//
//  ViewController.swift
//  Calculator
//
//  Created by macbook on 11/22/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var sequence: UILabel!
    
    var userIsInTheMiddleOfTyping = false // "flag" variable to remove initial 0
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if digit == ".", !textCurrentlyInDisplay.contains(".") {
                display.text = textCurrentlyInDisplay + digit
            } else if digit != "." {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = numberFormatter(String(newValue))
        }
    }
    
    private var brain = CalculatorBrain() // model, no initializers as we dont have uninitialized vars
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        if let resultDescription = brain.sequence {
            print(brain.resultIsPending)
            if brain.resultIsPending {
                sequence.text = resultDescription + "..."
            } else {
                sequence.text = resultDescription + "="
            }
        }
        
        if sender.currentTitle == "C" {
            brain = CalculatorBrain()
            display.text = numberFormatter("0")
            sequence.text = "0"
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

