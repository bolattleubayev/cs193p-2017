//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by macbook on 10/26/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

// ADDED AFTER LECTURE 14
// this is the delegate protocol for EmojiArtView
// EmojiArtView wants to be able to let people
// (usually its Controller)
// know when its contents have changed
// but MVC does not allow it to have a pointer to its Controller
// it must communicate "blind and structured"
// this is the "structure" for such communication
// see the delegate var in EmojiArtView below
// note that this protocol can only be implemented by a class
// (not a struct or enum)
// that's because the var with this type is going to be weak
// (to avoid memory cycles)
// and weak implies it's in the heap
// and that implies its a reference type (i.e. a class)

protocol EmojiArtViewDelegate: class {
    func emojiArtViewDidChange(_ sender: EmojiArtView)
}

// creating our own Notification.Name "radio station"
extension Notification.Name {
    static let EmojiArtViewDidChange = Notification.Name("EmojiArtViewDidChange")
}
class EmojiArtView: UIView, UIDropInteractionDelegate {
    // MARK: - Delegation
    
    // ADDED AFTER LECTURE 14
    // if a Controller wants to find out when things change
    // in this EmojiArtView
    // the Controller has to sign up to be the EmojiArtView's delegate
    // then it can have methods in that protocol invoked on it
    // this delegate is notified every time something changes
    // (see uses of this delegate var below and in EmojiArtView+Gestures.swift)
    // this var is weak so that it does not create a memory cycle
    // (i.e. the Controller points to its View and its View points back)
    weak var delegate: EmojiArtViewDelegate?
    
    // adding emoji drop on canvas interaction in its initializers
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addInteraction(UIDropInteraction(delegate: self))
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSAttributedString.self) { providers in
            let dropPoint = session.location(in: self)
            for attributedString in providers as? [NSAttributedString] ?? [] {
                self.addLabel(with: attributedString, centeredAt: dropPoint)
                self.delegate?.emojiArtViewDidChange(self) // ADDED AFTER L14
                // "broadcasting" on our "radio station"
                NotificationCenter.default.post(name: .EmojiArtViewDidChange, object: self) // inference of .EmojiArtViewDidChange from Notification.Name
            }
        }
    }
    
    private var labelObservations = [UIView:NSKeyValueObservation]() // declaring a dictionary, as soon as EmojiArt leaves the heap, this leaves the heap and therefore all the observations leave the heap
    
    public func addLabel(with attributedString: NSAttributedString, centeredAt point: CGPoint) {
        let label = UILabel()
        label.backgroundColor = .clear
        label.attributedText = attributedString
        label.sizeToFit()
        label.center = point
        addEmojiArtGestureRecognizers(to: label) // adding gestur recognizers from EmojiArtView+Gestures.swift
        addSubview(label)
        // telling that center of the label has changed, we also removed parts with broadcasting from EmojiArtView+Gestures file
        labelObservations[label] = label.observe(\.center) { (label, change) in
            self.delegate?.emojiArtViewDidChange(self)
            NotificationCenter.default.post(name: .EmojiArtViewDidChange, object: self)
        }
    }
    
    // gets called every time a subview gets removed, we create this to stop observing if we
    // implement subview removal
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        // if a view is getting removed, stop observing
        if labelObservations[subview] != nil {
            labelObservations[subview] = nil
        }
        
        
    }
    
    var backgroundImage: UIImage? { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in:bounds)
    }
}
