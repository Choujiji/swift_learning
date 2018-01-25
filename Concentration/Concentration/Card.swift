//
//  Card.swift
//  Concentration
//
//  Created by mac on 2017/11/27.
//  Copyright © 2017年 jiji. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var hashValue: Int {
        return self.identifier
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
