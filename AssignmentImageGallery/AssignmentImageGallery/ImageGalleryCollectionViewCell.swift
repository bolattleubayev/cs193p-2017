//
//  ImageGalleryCollectionViewCell.swift
//  AssignmentImageGallery
//
//  Created by macbook on 10/31/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
    
    var imageURL: URL? {
        didSet {
            fetchImage()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var imageIcon: UIImageView! {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    private func fetchImage() {
        
        if let url = imageURL?.imageURL {
            
            // start activity indicator here, stop when image actually gets set
            spinner.startAnimating()
            
            // putting code out of the main queue asyncronously
            // doing network fetch out of the main queue
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                // we don't care for the error, so we dont use "do-catch"
                let urlContents = try? Data(contentsOf: url.imageURL) // optional content var
                // dispatching code back to the main queue as views rely on the data from here
                DispatchQueue.main.async {
                    
                    if let imageData = urlContents, url == self?.imageURL?.imageURL { // also check if url that returned corresponds to the one requested at the moment
                        // in closures you need to use self.
                        // I don't want to keep the image in the heap if user doesn't care for it anymore
                        // so app should not care too
                        self!.spinner?.stopAnimating() // stop animating activity indicator
                        self?.imageIcon.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
}

