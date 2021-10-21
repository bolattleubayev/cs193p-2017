//
//  ViewController.swift
//  PlayingCard
//
//  Created by macbook on 10/4/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit
import CoreMotion
class ViewController: UIViewController {

    var deck = PlayingCardDeck()
    
    @IBOutlet private var cardViews: [PlayingCardView]!

    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardBehaviour = CardBehavior(in: animator)
    
    //turn on accelerometer while we are on screen, and off when off screen
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // check if accelerometer availabel
        if CMMotionManager.shared.isAccelerometerAvailable {
            cardBehaviour.gravityBehaviour.magnitude = 1.0 // turn on gravity in card behaviour
            CMMotionManager.shared.accelerometerUpdateInterval = 1/10 //setting the update interval
            CMMotionManager.shared.startAccelerometerUpdates(to: .main) { (data, error) in
                if var x = data?.acceleration.x, var y = data?.acceleration.y {
                    // changing coordinate systems from software ones to real
                    switch UIDevice.current.orientation {
                    case .portrait: y *= -1
                    case .portraitUpsideDown: break
                    case .landscapeRight: swap(&x, &y)
                    case .landscapeLeft: swap(&x, &y); y *= -1
                    default: x = 0; y = 0;
                    }
                    self.cardBehaviour.gravityBehaviour.gravityDirection = CGVector(dx: x, dy: y)
                }
            } //register a closure with a motion manager with accelerometer updates
        }
    }
    
    
    
    
    
    //
    //    @IBOutlet weak var playingCardView: PlayingCardView! {
    //        didSet {
    //            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
    //            swipe.direction = [.left, .right]
    //            playingCardView.addGestureRecognizer(swipe)
    //            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
    //            playingCardView.addGestureRecognizer(pinch)
    //        }
    //    }
    //
    //    // tap gesture recognizer and card flip
    //    // we dragged and dropped the tap gesture from objects library
    //    // to storyboard
    //    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
    //        switch sender.state {
    //        case .ended:
    //            playingCardView.isFaceUp = !playingCardView.isFaceUp
    //        default: break
    //        }
    //
    //    }
    //
    //
    //    // add @objc to use swipe gesture targetiing, as it is done in Objective C
    //    @objc func nextCard() {
    //        if let card = deck.draw() {
    //            playingCardView.rank = card.rank.order
    //            playingCardView.suit = card.suit.rawValue
    //        }
    //    }
    //
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // stopping the accelerometer recore
        cardBehaviour.gravityBehaviour.magnitude = 0
        CMMotionManager.shared.stopAccelerometerUpdates()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehaviour.addItem(cardView)
        }
    }
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter {$0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) && $0.alpha == 1}
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 &&
        faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
        faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    var lastChosenCardView: PlayingCardView?
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView, faceUpCardViews.count < 2 {
                lastChosenCardView = chosenCardView
                cardBehaviour.removeItem(chosenCardView)
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.6,
                    options: [.transitionFlipFromLeft],
                    animations: {
                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                    },
                    // when two cards are face up, turn them face down
                    completion:  {finished in
                        // match animation
                        let cardsToAnimate = self.faceUpCardViews
                        if self.faceUpCardViewsMatch {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    cardsToAnimate.forEach {
                                        // enlarging card 3 times
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                    }
                                },
                                completion: { position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            cardsToAnimate.forEach {
                                                //diminishing card and setting it transparrent
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                        },
                                        completion: { position in
                                            // cleaning removed cards from view
                                            cardsToAnimate.forEach {
                                                $0.isHidden = true
                                                $0.alpha = 1
                                                $0.transform = .identity
                                            }
                                        }
                                    )
                                }
                            )
                        } else if cardsToAnimate.count == 2 {
                            if chosenCardView == self.lastChosenCardView {
                                // change the face up state to inverse
                                // there is a danger of a loop, so we should add self
                                cardsToAnimate.forEach { cardView in
                                    UIView.transition(
                                        with: cardView,
                                        duration: 0.6,
                                        options: [.transitionFlipFromLeft],
                                        animations: {
                                            cardView.isFaceUp = false
                                        },
                                        completion:  { finished in
                                            self.cardBehaviour.addItem(cardView)
                                        }
                                    )
                                }
                            }
                        } else {
                            if !chosenCardView.isFaceUp {
                                self.cardBehaviour.addItem(chosenCardView)
                            }
                        }
                    }
                )
            }
        default:
            break
        }
    }
}


extension CGFloat {
    var arc4random: CGFloat {
        if self > CGFloat(0.0) {
            return CGFloat(arc4random_uniform(UInt32(self)))
        } else if self < CGFloat(0.0) {
            return -CGFloat(arc4random_uniform(UInt32(-self)))
        } else {
            return CGFloat(0.0)
        }
    }

}
