//
//  GallerySectionTableViewCell.swift
//  AssignmentImageGallery
//
//  Created by macbook on 11/9/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class GallerySectionTableViewCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameEditCell.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var nameEditCell: UITextField! {
        didSet {
            nameEditCell.delegate = self
        }
    }
    
    // The row's title.
    var cellName: String {
        set {
            nameEditCell?.text = newValue
        }
        get {
            return nameEditCell.text ?? ""
        }
    }
    
    
    override var isEditing: Bool {
        didSet {
            nameEditCell.isEnabled = isEditing
            if isEditing == true {
                nameEditCell.becomeFirstResponder()
            } else {
                cellName = ""
                nameEditCell.isEnabled = isEditing
                nameEditCell.resignFirstResponder()
            }
        }
    }
    
    var resignationHandler: (() -> Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?() // when someone is interested in resignation of the cell, anyone can go and edit it
    }
    
    // puts keyboard away once you hit enter, if you don't do this, keyboard will stay up
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameEditCell.isEnabled = false
        textField.resignFirstResponder()
        return true
    }
    
}
