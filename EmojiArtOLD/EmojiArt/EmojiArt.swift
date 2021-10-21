//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by macbook on 11/9/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import Foundation

struct EmojiArt: Codable // Codable makes file JSON convertible
{
    var url: URL
    var emojis = [EmojiInfo]()
    
    // values are Ints (could be double, but Int looks nicer), (not CGFloats for example), because it is a model, not a UI thing
    struct EmojiInfo: Codable {
        let x: Int
        let y: Int
        let text: String
        let size: Int
    }
    
    // failable initializer, if it fails, the other initializer will take place
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(EmojiArt.self, from: json){
            self = newValue
        } else {
            return nil
        }
    }
    
    // getting JSON file, actually it is never going to fail, because all types are 100% codable
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init(url: URL, emojis: [EmojiInfo]) {
        self.url = url
        self.emojis = emojis
    }
}
