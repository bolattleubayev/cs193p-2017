//
//  ViewController.swift
//  setCardDrawing
//
//  Created by macbook on 10/10/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

let screenRect = UIScreen.main.bounds
let screenWidth = screenRect.size.width
let screenHeight = screenRect.size.height
let controlPanelHeight = 150
let spaceBetweenCards = 5
class SetGameViewController: UIViewController {
    
    lazy var game = setGame(numberOfCards: 0)
    
    private var setCardButtons: [UIButton] = []
    private var newDeckViewArray: UIView?
    private var discardedDeckViewArray: UIView?
    
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet{
            updateScore()
        }
    }
    
    private func updateScore() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ]
        
        let attributedString = NSAttributedString(string: "Score: \(game.score)", attributes: attributes)
        scoreLabel.attributedText = attributedString
        
    }
    
    // Adding recognition of swipe down action
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownAction))
        swipe.direction = [.down]
        view.addGestureRecognizer(swipe)
    }
    
    @IBAction func rotationWithTwoFingers(_ sender: Any) {
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotationAction))
        view.addGestureRecognizer(rotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        for _ in 0..<game.cards.count {
            let customButton = setCardButton()
            customButton.isFaceUp = false
            setCardButtons += [customButton]
            
            customButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            self.view.addSubview(customButton)
            
        }
        if Int(game.cards.count + game.deck.cards.count) != 81 {
            if discardedDeckViewArray == nil{
                print("Initializing discarded deck")
                let discardedDeckView = cardDeckView()
                discardedDeckView.backgroundColor = UIColor.clear
                discardedDeckViewArray = discardedDeckView
                view.addSubview(discardedDeckView)
            }
        }
        
        if game.deck.cards.count > 0 {
            if let deck = newDeckViewArray as? cardDeckView {
                deck.removeFromSuperview()
            }
            let screenSize: CGRect = UIScreen.main.bounds
            let newDeckView = cardDeckView()
            newDeckView.backgroundColor = UIColor.clear
            newDeckView.frame = CGRect.init(x: Int((Int(screenSize.width)) / 3),
                                            y: Int((Int(screenSize.height)) / 4),
                                            width: Int((Int(screenSize.width)) / 3),
                                            height: Int((Int(screenSize.height)) / 4))
            newDeckViewArray = newDeckView
            view.addSubview(newDeckView)
        } else {
            newDeckViewArray?.removeFromSuperview()
        }
        
    }

    
    private func updateViewFromModel() {
        
        let guide = view.safeAreaLayoutGuide
        let screenSize: CGRect = UIScreen.main.bounds
        
        var slotWidth = Int((Int(screenSize.width)) / 3)
        var slotHeight = Int((Int(screenSize.height)) / 4)
        
        var row = 0
        var column = 0
        // Calculating safe area
        let topMargin = Int((screenSize.height - guide.layoutFrame.size.height)/2)
        let sideMargin = Int((screenSize.width - guide.layoutFrame.size.width)/2)
        
        
        for index in 0..<game.cards.count {
            if game.cards[index].isSet {
                
                row = Int(floor((Double(index)) / 3.0))
                column = Int(index - row * 3) % 3
                
                slotHeight = Int((Int(screenSize.height)  - topMargin) / (1 + game.cards.count / 3))
                slotWidth = Int((Int(screenSize.width)) / 3)
                
                
                
                if let button = setCardButtons[index] as? setCardButton {
                    
                    UIButton.transition(with: button,
                                        duration: 0.6,
                                        options: [.curveEaseOut],
                                        animations: {
                                            // translation
                                            let xdiff = CGFloat(sideMargin - 2 * slotWidth)
                                            let ydiff = CGFloat(topMargin)
                                            button.transform = CGAffineTransform(translationX: xdiff, y: ydiff)
                                        },
                                        completion: {
                                            finished in
                                            UIButton.transition(
                                                with: button,
                                                duration: 0.6,
                                                options: [.transitionFlipFromLeft],
                                                animations: {
                                                    button.isFaceUp = false
                                                },
                                                completion: {
                                                    finished in
                                                    
                                                    var adder = 0
                                                    
                                                    for indexRemoval in 0..<self.game.cards.count {
                                                        if self.game.cards[indexRemoval - adder].isSet {
                                                            if let buttonToRemove = self.setCardButtons[indexRemoval - adder] as? setCardButton {
                                                                print("card at:\(self.setCardButtons.firstIndex(of: buttonToRemove) ?? -1), from:\(self.game.cards.count)")
                                                                self.game.cards.remove(at: self.setCardButtons.firstIndex(of: buttonToRemove) ?? -1)
                                                                self.setCardButtons = self.setCardButtons.filter {$0 != buttonToRemove}
                                                                buttonToRemove.removeFromSuperview()
                                                                adder += 1
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                            )
                                        }
                                    )
                    
                }
                
            }
        }
        
        for index in 0..<game.cards.count {
            if let button = setCardButtons[index] as? setCardButton {
                let card = game.cards[index]
                if !card.isSet {
                    // Highlighting selected cards
                    button.layer.cornerRadius = 8.0
                    //button.backgroundColor = card.isSelected ? #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    button.layer.borderWidth = card.isSelected ? 3.0 : 0.0
                    button.layer.borderColor = UIColor.blue.cgColor
                
                    // Calculating slot sizes based on orientation
                    // Locating card on screen and assigning size
                    // index starts from 0 and goes to last card number
                    // total (game.cards.count+1) is always divisible by 3
                    // (game.cards.count + 1) / 3 -> number of rows
                    // 3 columns
                    // floor((index + 1) / 3) -> row #
                    // (index + 1 - row * 3) % 3 -> column #
                    
                    // Row and column number
                    row = Int(floor((Double(index)) / 3.0))
                    column = Int(index - row * 3) % 3
                    
                    slotHeight = Int((Int(screenSize.height)  - topMargin) / (1 + game.cards.count / 3))
                    slotWidth = Int((Int(screenSize.width)) / 3)
                    
                    UIButton.transition(with: button,
                                         duration: 0.6,
                                         options: [.curveEaseIn],
                                         animations: {
                                            // translation
                                            let xdiff = CGFloat(sideMargin + column * slotWidth - (sideMargin + 2 * slotWidth))
                                            let ydiff = CGFloat(topMargin + row * slotHeight) - CGFloat((Int(floor((Double(self.game.cards.count)) / 3.0))) * slotHeight)
                                            
                                            button.transform = CGAffineTransform(translationX: xdiff, y: ydiff)
                                            
                                            },
                                         completion: {
                                                finished in
                                                if !button.isFaceUp {
                                                    UIButton.transition(
                                                        with: button,
                                                        duration: 0.6,
                                                        options: [.transitionFlipFromLeft],
                                                        animations: {
                                                            button.isFaceUp = true
                                                    }
                                                    )
                                                }
                                            }
                                        )
                    
                    
                    button.frame = CGRect.init(x: sideMargin + column * slotWidth, y: topMargin + row * slotHeight, width: slotWidth - sideMargin / 4, height: slotHeight - topMargin / 4)
                    
                    button.cardWidth = slotWidth
                    button.cardHeight = slotHeight
                    button.color = card.color.rawValue
                    button.shape = card.shape.rawValue
                    button.shade = card.shade.rawValue
                    button.numberOfShapes = card.numberOfShapes.rawValue
                }
            }
            
        }
        
        print("cards in game: \(game.cards.count), cards in deck: \(game.deck.cards.count)")
        
        if let deck = discardedDeckViewArray as? cardDeckView {
            // if y coordinate is 0 i.e. at the beginning of the game
            var originator = (Int(floor((Double(game.cards.count)) / 3.0))) * slotHeight
            if originator == 0 {
                originator = Int((Int(screenSize.height))) - slotHeight - topMargin
                print(originator)
            }
            
            deck.frame = CGRect.init(x: sideMargin, y: topMargin + originator, width: slotWidth - sideMargin / 4, height: slotHeight - topMargin / 4)
        }
        
        if let deck = newDeckViewArray as? cardDeckView {
            // if y coordinate is 0 i.e. at the beginning of the game
            var originator = (Int(floor((Double(game.cards.count)) / 3.0))) * slotHeight
            if originator == 0 {
                originator = Int((Int(screenSize.height))) - slotHeight - topMargin
                print(originator)
            }
            
            deck.frame = CGRect.init(x: sideMargin + 2 * slotWidth, y: topMargin + originator, width: slotWidth - sideMargin / 4, height: slotHeight - topMargin / 4)
        }
        
        updateScore()
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        if let cardNumber = setCardButtons.firstIndex(of: sender){
            game.chooseCards(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @objc func swipeDownAction() {
        game.addCard()
        viewDidLoad()
        updateViewFromModel()
    }

    @objc func rotationAction() {
        game.cards.shuffle()
        viewDidLoad()
        updateViewFromModel()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        for button in setCardButtons {
            button.removeFromSuperview()
        }
        setCardButtons = []
        game = setGame(numberOfCards: 12)
        viewDidLoad()
        updateViewFromModel()
    }
    
    @IBAction func dealMoreCards(_ sender: UIButton) {
        game.addCard()
        viewDidLoad()
        updateViewFromModel()
    }
    
    @objc func rotate(){
        // Update card contents when device is rotated
        updateViewFromModel()
        for index in 0..<game.cards.count {
            let button = setCardButtons[index]
            button.setNeedsDisplay()
            button.setNeedsLayout()
        }
    }
}

