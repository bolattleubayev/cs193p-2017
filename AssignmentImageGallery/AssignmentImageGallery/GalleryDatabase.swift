//
//  GalleryDatabase.swift
//  AssignmentImageGallery
//
//  Created by macbook on 11/7/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import Foundation

class GalleryDatabase {
    
    static var documents: [[ImageGallerySection]] = [mainSection, deletedSection]
    
    static func insert(section: Int, index: Int, newItem: ImageGallerySection) {
        print("Insert section: \(section), index: \(index), to sections.count:\(documents.count), galleries.count:\(documents[section].count)")
        documents[section].insert(newItem, at: index)
    }
    
    static func remove(section: Int, index: Int) {
        documents[section].remove(at: index)
    }
    
    private static var mainSection: [ImageGallerySection] = [
        ImageGallerySection(name: "Default Gallery", items: [])
        ]
    
    private static var deletedSection: [ImageGallerySection] = []
}
