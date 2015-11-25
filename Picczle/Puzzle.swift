//
//  Puzzle.swift
//  Picczle
//
//  Created by Nick Arnold on 11/24/15.
//  Copyright © 2015 Swiss. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Puzzle: Equatable {
    
    var id: String
    var title: String
    var imageURL: String
    var message: String
    
    init(id: String, title: String, imageURL: String, message: String) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.message = message
    }
    
    static func puzzlesFromJSON(json: JSON) -> [Puzzle] {
        var puzzles: [Puzzle] = []
        for(var i = 0; i < json.count; i++) {
            puzzles.append(puzzleFromJSON(json[i]))
        }
        return puzzles
    }
    
    static func puzzleFromJSON(json: JSON) -> Puzzle {
        let id = json["id"].stringValue
        let title = json["title"].stringValue
        let image = json["image"].stringValue
        let message = json["message"].stringValue
        let p = Puzzle(id: id, title: title, imageURL: image, message: message)
        
        return p
    }
}

func == (lhs: Puzzle, rhs: Puzzle) -> Bool {
    return lhs.id == rhs.id
}