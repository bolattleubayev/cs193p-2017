//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by macbook on 11/9/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

class EmojiArtDocument: UIDocument
{
    
    var emojiArt: EmojiArt?
    var thumbnail: UIImage?
    
    // return either json or empty Data type
    override func contents(forType typeName: String) throws -> Any {
        return emojiArt?.json ?? Data()
    }
    
    // if it can read, it will be unwrapped as emojiArt, otherwise nothing happens
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data {
            emojiArt = EmojiArt(json: json)
        }
    }
    
    // adding thumbnail to app files
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocument.SaveOperation) throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        if let thumbnail = self.thumbnail {
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey:thumbnail]
        }
        return attributes
    }
}

