//
//  DocumentInfoViewController.swift
//  EmojiArt
//
//  Created by macbook on 11/13/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class DocumentInfoViewController: UIViewController
{
    var document: EmojiArtDocument? {
        didSet { updateUI() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // converting date to string with short format
    private let  shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    // connection to the document
    private func updateUI() {
        if sizeLabel != nil, createdLabel != nil, // protection from files that are not yet set
            let url = document?.fileURL,
            let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) {
            sizeLabel.text = "\(attributes[.size] ?? 0) bytes"
            if let created = attributes[.creationDate] as? Date {
                createdLabel.text = shortDateFormatter.string(from: created)
            }
        }
        if thumbnailImageView != nil, thumbnailAspectRatio != nil, let thumbnail = document?.thumbnail {
            thumbnailImageView.image = thumbnail
            // aspect ratio constraint is read only, so we need to remove it and add a new one
            thumbnailImageView.removeConstraint(thumbnailAspectRatio) // remove previous constraint
            thumbnailAspectRatio = NSLayoutConstraint(
                item: thumbnailImageView,
                attribute: .width,
                relatedBy: .equal,
                toItem: thumbnailImageView,
                attribute: .height,
                multiplier: thumbnail.size.width / thumbnail.size.height,
                constant: 0
            )
            thumbnailImageView.addConstraint(thumbnailAspectRatio) // putting a new constraint
        }
        if presentationController is UIPopoverPresentationController {
            thumbnailImageView?.isHidden = true
            returnToDocumentButton?.isHidden = true
            view.backgroundColor = .clear
        }
    }
    
    // making contents of stack view fit to the smallest size possible
    override func viewDidLayoutSubviews() { // recommended place to put your geometry stuff
        super.viewDidLayoutSubviews()
        if let fittedSize = topLevelView?.sizeThatFits(UIView.layoutFittingCompressedSize) { // UIView.layoutFittingCompressedSize was UILayoutFittingCompressedSize in previous versions, returns smallest size possible
            preferredContentSize = CGSize(width: fittedSize.width + 30, height: fittedSize.height + 30)
        }
    }
    
    @IBAction func done() {
        presentingViewController?.dismiss(animated: true)
    }
    
    
    @IBOutlet weak var returnToDocumentButton: UIButton!
    @IBOutlet weak var topLevelView: UIStackView!
    @IBOutlet weak var thumbnailAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
}
