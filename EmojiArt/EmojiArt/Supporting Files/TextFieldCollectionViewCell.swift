//
//  TextFieldCollectionViewCell.swift
//  EmojiArt
//
//  Created by macbook on 11/5/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    var resignationHandler: (() -> Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?() // when someone is interested in resignation of the cell, anyone can go and edit it
    }
    
    // puts keyboard away once you hit enter, if you don't do this, keyboard will stay up
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
