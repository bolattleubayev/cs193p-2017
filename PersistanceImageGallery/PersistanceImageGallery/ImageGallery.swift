//
//  ImageGallerySection.swift
//  AssignmentImageGallery
//
//  Created by macbook on 11/2/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import Foundation

struct ImageGallery: Codable {
    
    // Gallery Items
    var items = [ImageGalleryInfo]()
    
    struct ImageGalleryInfo: Codable {
        var imageURL: URL
        var ratio: AspectRatio
    }
    
    struct AspectRatio: Codable {
        var width: Int
        var height: Int
    }
    
    // failable initializer, if it fails, the other initializer will take place
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(ImageGallery.self, from: json){
            self = newValue
        } else {
            return nil
        }
    }
    
    // getting JSON file, actually it is never going to fail, because all types are 100% codable
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    // Initialization
    init(items: [ImageGalleryInfo]) {
        self.items = items
    }
    
    init(){}
}
