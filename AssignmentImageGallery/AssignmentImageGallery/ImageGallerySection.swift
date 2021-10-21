//
//  ImageGallerySection.swift
//  AssignmentImageGallery
//
//  Created by macbook on 11/2/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import Foundation

struct ImageGallerySection {
    
    // Gallery name
    var name: String = "Default Gallery"
    
    // Gallery Items
    var items = [Item]()
    
    struct Item {
        var imageURL: URL
        var ratio: AspectRatio
    }
    
    struct AspectRatio {
        var width: Int
        var height: Int
    }
    
    // Initialization
    init(name: String, items: [Item]) {
        self.name = name
        self.items = items
    }
    
    // Empty init
    init() {}
}
