//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by mac on 2018/1/29.
//  Copyright © 2018年 jiji. All rights reserved.
//

import Foundation


struct PlayingCardDeck {
    /** set是设置setter为private，getter仍然是public */
    private(set) var cards = [PlayingCard]()
    
    init() {
        // 初始化一整副牌（4种花色，每种13张）
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    /** 随机抽一张牌（没有牌时返回nil）
     【由于self的属性不可修改，修改时需要func为mutating的，使用了copy on write特性】
    */
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
}

extension Int {
    /** 随机整数 */
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else {
            return -Int(arc4random_uniform(UInt32(self)))
        }
    }
}
