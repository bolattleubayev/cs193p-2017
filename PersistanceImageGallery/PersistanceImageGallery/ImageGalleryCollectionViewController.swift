//
//  ImageGalleryCollectionViewController.swift
//  AssignmentImageGallery
//
//  Created by macbook on 10/31/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit


private let reuseIdentifier = "ImageCell"

class ImageGalleryCollectionViewController: UICollectionViewController, UIDropInteractionDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    var imageGallery = ImageGallery()
    
    // MARK: - Document Management
    
    var document: ImageGalleryDocument?
    
    @IBAction func save(_ sender: UIBarButtonItem? = nil) {
//        if let json = imageGallery.json {
////            if let jsonString = String(data: json, encoding: .utf8) {
////                print(jsonString)
////            }
//            if let url = try? FileManager.default.url(
//                for: .documentDirectory,
//                in: .userDomainMask,
//                appropriateFor: nil,
//                create: true
//                ).appendingPathComponent("Untitled.json") {
//                do {
//                    try json.write(to: url)
//                    print("saved successfully!")
//                } catch let error {
//                    print("couldn't save \(error)")
//                }
//
//            }
//        }
        
        document?.imageGallery = imageGallery
        if document?.imageGallery != nil {
            document?.updateChangeCount(.done)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if let url = try? FileManager.default.url(
//            for: .documentDirectory,
//            in: .userDomainMask,
//            appropriateFor: nil,
//            create: true
//        ).appendingPathComponent("Untitled.json") {
//            if let jsonData = try? Data(contentsOf: url) {
//                imageGallery = ImageGallery(json: jsonData)!
//            }
//        }
        
        document?.open { success in
            if success {
                self.title = self.document?.localizedName
                if self.document!.imageGallery != nil {
                    self.imageGallery = self.document!.imageGallery!
                    self.imageGalleryCollectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        save()
        if document?.imageGallery != nil {
            document?.thumbnail = imageGalleryCollectionView.snapshot
        }
        dismiss(animated: true) {
            self.document?.close()
        }
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        if let url = try? FileManager.default.url(
//            for: .documentDirectory,
//            in: .userDomainMask,
//            appropriateFor: nil,
//            create: true
//        ).appendingPathComponent("Untitled.json") {
//            document = ImageGalleryDocument(fileURL: url)
//        }
//    }
    
    // MARK: - Caching
    
    private var cache = URLCache.shared // recommended to us this by Apple
    private var session = URLSession(configuration: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // but for assignment we can do this
        cache = URLCache(memoryCapacity: 5*1024*1024, diskCapacity: 30*1024*1024, diskPath: nil) // replace capacities with your own values
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        // prepare for segue
        if segue.identifier == "OpenImage" {
            if let imageVC = segue.destination.contents as? SingleImageViewController {
                if let senderCell = sender as? ImageGalleryCollectionViewCell {
                    imageVC.imageURL = senderCell.imageURL
                    imageVC.title = segue.source.contents.title
                }
            }
        }
    }
 
    
    //
    
    // MARK: UICollectionViewDataSource
    
    @IBOutlet weak var imageGalleryCollectionView: UICollectionView! {
        didSet {
            imageGalleryCollectionView.addInteraction(UIDropInteraction(delegate: self))
            imageGalleryCollectionView.dataSource = self // should be automatically done for packaged Collection View
            imageGalleryCollectionView.delegate = self // should be automatically done for packaged Collection View
            imageGalleryCollectionView.dragDelegate = self
            imageGalleryCollectionView.dropDelegate = self
            imageGalleryCollectionView.reloadData()
            imageGalleryCollectionView.dragInteractionEnabled = true
            // UI Gestures
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchToResize(gesture:)))
            imageGalleryCollectionView.addGestureRecognizer(pinchGesture)
        }
    }
    
    
    // Pinch gesture handler
    @objc private func pinchToResize(gesture recognizer: UIPinchGestureRecognizer) {
        
        // Process .changed state
        if recognizer.state == .changed {
            
            // Change width and reset scale
            cellWidth *= recognizer.scale
            recognizer.scale = 1.0
            
            // Make sure cellWidth is not too big nor too small
            if cellWidth > imageGalleryCollectionView.bounds.size.width {
                // Cap the width to a max. of the collectionView's bound width
                cellWidth = collectionView.bounds.size.width
            }
            else if cellWidth < 80.0 {
                // Minimun width of 80
                cellWidth = 80.0
            }
            
            //
            // invalidateLayout(): Invalidates the current layout and triggers a layout update.
            // You can call this method at any time to update the layout information. This method invalidates the
            // layout of the collection view itself and returns right away. Thus, you can call this method multiple
            // times from the same block of code without triggering multiple layout updates. The actual layout
            // update occurs during the next view layout update cycle.
            //
            imageGalleryCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    // width of individual cell
    private(set) lazy var cellWidth: CGFloat = imageGalleryCollectionView.bounds.width / 3.1
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Get aspect ratio of the image to display
        let ratio = imageGallery.items[indexPath.item].ratio
        
        // Height is calculated based on the width and aspect ratio
        let height: CGFloat = (cellWidth * CGFloat(ratio.height)) / CGFloat(ratio.width)
        
        // The cell's size
        return CGSize(width: cellWidth, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView // for local move
        return dragItems(at: indexPath)
    }
    
    // adding multi-touch during drag
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at:indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let url = (imageGalleryCollectionView.cellForItem(at: indexPath) as? ImageGalleryCollectionViewCell)?.imageURL {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: url as NSItemProviderWriting))
            dragItem.localObject = url
            return [dragItem]
        } else {
            return []
        }
    }
    
    
    // Following thress methods allow us to move objects around
    // within collection view
    // Check if collection view can handle the object of type UIImage
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        
        // drop from outside
        if session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self) {
            return true
        }
        // local drop
        if (session.localDragSession?.localContext as? UICollectionView) == collectionView {
            return true
        }
        
        return false
    }
    
    // Check if object have moved
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath) // if it is self drag then move otherwise copy
    }
    
    
    // Drop the object, UIImage in our case
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
        ) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath { // local case
                
                if let galleryImageURL = item.dragItem.localObject as? URL {
                    // performBatchUpdates will do small updates without crashing the program and getting out of sync
                    // do it to do multiple updates to tableview or collectionview
                    collectionView.performBatchUpdates({
                        // updating the model, i.e. string with emojis
                        // removing item at location
                        let ratio = imageGallery.items[sourceIndexPath.item].ratio
                        imageGallery.items.remove(at: sourceIndexPath.item)
                        // adding item back to the collection view to a new location
                        imageGallery.items.insert(ImageGallery.ImageGalleryInfo(imageURL: galleryImageURL, ratio: ratio), at: destinationIndexPath.item)
                        // update collection view
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                        
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else { // from outside the app
                
                var ratio: ImageGallery.AspectRatio?
                
                let placeholderContext = coordinator.drop(
                    item.dragItem,
                    to: UICollectionViewDropPlaceholder(
                        insertionIndexPath: destinationIndexPath,
                        reuseIdentifier: "DropPlaceholderCell" // "DropPlaceholderCell" contains a loading spinning wheel
                    )
                )
                
                
                // Get the image
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    DispatchQueue.main.async {
                        // Is this a valid UIImage?
                        if let image = provider as? UIImage {
                            // Get the aspect ratio of the image
                            ratio = ImageGallery.AspectRatio(width: Int(image.size.width), height: Int(image.size.height))
                        } else {
                            // if there is an errror loading the string, delete the placeholder
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
                
                // Get the url
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let url = provider, ratio != nil {
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.imageGallery.items.insert(ImageGallery.ImageGalleryInfo(imageURL: url as! URL, ratio: ratio!), at: insertionIndexPath.item)
                            })
                        } else {
                            // if there is an errror loading the string, delete the placeholder
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
            self.save()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let imageCell = cell as? ImageGalleryCollectionViewCell {
            
            imageCell.imageURL = nil
            imageCell.imageIcon.isHidden = true
            
            let url = imageGallery.items[indexPath.item]
            
            let request = URLRequest(url: url.imageURL) // imageURL from Utilities.swift of Stanford iOS course
            if let cachedResponse = cache.cachedResponse(for: request), let image = UIImage(data: cachedResponse.data) {
                imageCell.imageURL = url.imageURL
                imageCell.imageIcon.isHidden = false
            } else {
                DispatchQueue.global(qos: .userInitiated).async { [weak self, weak imageCell] in
                    let task = self?.session.dataTask(with: request) { (urlData, urlResponse, urlError) in
                        DispatchQueue.main.async {
                            if urlError != nil { print("Data request failed with error \(urlError!)") }
                            if let data = urlData, let image = UIImage(data: data) {
                                if let response = urlResponse {
                                    self?.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                                }
                                imageCell?.imageURL = url.imageURL
                            } else {
                                imageCell?.imageIcon.image = UIImage(named: "placeholder")
                            }
                            imageCell?.imageIcon.isHidden = false
                        }
                    }
                    task?.resume()
                }
            }
            
            
            
        }
        
        return cell
    }
    
    

}

