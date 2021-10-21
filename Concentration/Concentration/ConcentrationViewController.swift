//
//  ViewController.swift
//  Concentration
//
//  Created by macbook on 8/29/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        get {
            return (visibleCardButtons.count+1) / 2
        }
    }

    //MARK: Properties

    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    @IBOutlet private weak var scoreCountLabel: UILabel!
    
    //MARK: Actions
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBAction private func touchNewGameButton(_ sender: UIButton) {
        emojiChoices = "🦇😱🙀😈🎃👻🍭🍬🍎" //choose new random theme
        game = Concentration(numberOfPairsOfCards: (visibleCardButtons.count+1) / 2) //restart a game
        updateViewFromModel() //update view
    }
    
    //@IBOutlet var cardButons: Array<UIButton>! //also a legal declaration, similar to Java
    @IBOutlet private var cardButtons: [UIButton]!
    
    // fix to display hidden buttons when rotation happens
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter { !$0.superview!.isHidden }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = visibleCardButtons.firstIndex(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        
        let attributedString = NSAttributedString(string: traitCollection.verticalSizeClass == .compact ? "Flips\n\(game.flipCount)": "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    // update when device was rotated
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFlipCountLabel()
    }
    private func updateViewFromModel() {
        if visibleCardButtons != nil { // check for outlets that are not set yet
            updateFlipCountLabel()
            scoreCountLabel.text = "Score: \(game.scoreCount)"
            for index in visibleCardButtons.indices {
                let button = visibleCardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                }
            }
        }
    }
    

    var theme: String? {
        didSet{
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private lazy var emojiChoices = "🦇😱🙀😈🎃👻🍭🍬🍎"
    
    private var emoji = [Card:String]() //defining dictionary
    
    private func emoji(for card: Card) -> String {

        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }

        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
