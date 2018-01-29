//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by mac on 2018/1/29.
//  Copyright © 2018年 jiji. All rights reserved.
//

import Foundation

/** 【CustomStringConvertible是自定义字符串描述协议】 */
struct PlayingCard: CustomStringConvertible {
    var description: String {
        return "\(suit)\(rank)"
    }
    
    
    var suit: Suit
    var rank: Rank
    
    /** 花色 */
    enum Suit: String, CustomStringConvertible {
        var description: String {
            return "\(self.rawValue)"
        }
        
        case spades = "♠️"  // RawValue
        case hearts = "❤️"
        case clubs = "♣️"
        case diamonds = "♦️"
        
        /** 所有值（静态计算属性） */
        static var all = [Suit.spades, .hearts, .clubs, .diamonds]
    }
    /** 排行（类型默认为Int，与OC呼应） */
    enum Rank: CustomStringConvertible {
        var description: String {
            return "\(self.order)"
        }
        
        // 调用case时需要返回对应的RawValue
        /** A */
        case ace
        /** 2~10 */
        case numeric(Int)
        /** J Q K */
        case face(String)
        
        /** 传入case，返回对应RawValue */
        var order: Int {
            switch self {
            case .ace:
                return 1
            case .numeric(let pips):
                return pips // 直接返回数字
            case .face(let kind)
                where kind == "J":
                return 11
            case .face(let kind)
                where kind == "Q":
                return 12
            case .face(let kind)
                where kind == "K":
                return 13
            default:
                return 0
            }
        }
        
        /** 所有值（静态计算属性） */
        static var all: [Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
    }
}
