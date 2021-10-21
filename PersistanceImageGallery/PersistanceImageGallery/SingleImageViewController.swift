//
//  SingleImageViewController.swift
//  AssignmentImageGallery
//
//  Created by macbook on 11/7/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class SingleImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                // if I am on screen, I will go ahead and fetch the image
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            // resizing the scrollView content area so it is no 0 height 0 width rectangle
            imageView.sizeToFit()
            // scrollView should be optional as we are preparing segues before outlets
            // are set, needed to avoid crashing when called from master
            scrollView?.contentSize = imageView.frame.size
            singleSpinner?.stopAnimating() // stop animating activity indicator
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            // if I am not on screen, I will go ahead and fetch the image
            fetchImage()
        }
    }
    
    
    @IBOutlet weak var singleSpinner: UIActivityIndicatorView!
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            //changing zoom scale
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    var imageView = UIImageView()
    
    private func fetchImage() {
        if let url = imageURL {
            // start activity indicator here, stop when image actually gets set
            singleSpinner.startAnimating()
            
            // putting code out of the main queue asyncronously
            // doing network fetch out of the main queue
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                // we don't care for the error, so we dont use "do-catch"
                let urlContents = try? Data(contentsOf: url) // optional content var
                // dispatching code back to the main queue as views rely on the data from here
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL { // also check if url that returned corresponds to the one requested at the moment
                        // in closures you need to use self.
                        // I don't want to keep the image in the heap if user doesn't care for it anymore
                        // so app should not care too
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
