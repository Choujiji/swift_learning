//
//  Concentration.swift
//  Concentration
//
//  Created by mac on 2017/11/27.
//  Copyright © 2017年 jiji. All rights reserved.
//

import Foundation

class Concentration {
    var cards = [Card]()
    
    init(numberPairsOfCards: Int) {
        for _ in 1 ... numberPairsOfCards {
            let card = Card()
//            let matchingCard = card  // card为struct，即值类型，赋值是值copy
            cards += [card, card]   // 后一个是匹配的card实例（+=是运算符多态，数组支持这种append形式）
        }
        // TODO - shuffle所有card实例
        
    }
    
    // 有且仅有一个翻过来的card，的index
    // optional为nil或者指定的索引值
    // 计算属性
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            let isFacedUpArray = cards.indices.filter {
                cards[$0].isFaceUp
            }
//            return isFacedUpArray.count == 1 ? isFacedUpArray.first : nil
            return isFacedUpArray.oneAndOnly
            
//            var foundIndex: Int?
//            for index in cards.indices {
//                // 面朝上的card进行查看（对于翻过来的才有效）
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        // 没有朝向正面的，记录下来
//                        foundIndex = index
//                        print("found===")
//                    } else {
//                        // 已有，置为nil
//                        foundIndex = nil
//                        print("unfound!!!!!")
//                    }
//                }
//            }
//            return foundIndex
        }
        set {   // newValue
            // 只设置newValue的index为翻过来，其余为false
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            // 没有匹配时，
            
            print("select index = \(index)")
            print("indexOfOneAndOnlyFaceUpCard = \(String(describing: indexOfOneAndOnlyFaceUpCard))")
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                print("进入匹配~~~~~~")
                // 存在一个面朝上的card，并且这个card的index不是刚刚选择的index
                // （翻过来的是第二个card）
                // 所以，有两个card面朝上了，可以进行匹配了
                if cards[matchIndex] == cards[index] {
                    // 匹配成功
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                } else {
                    // 匹配失败（这里不处理，待下次choose时翻回去）
                }
                // 将刚刚选择的card翻过来
                cards[index].isFaceUp = true
//                // 有且只有一个翻过来的情况，不成立（恢复为not set）
//                indexOfOneAndOnlyFaceUpCard = nil // 下次访问计算属性时，自动设置了
                
            } else {
                print("直接设置！！！！！")
                // 没有面朝上的card，刚刚翻过来的是第一个card
                // 或者
                // 有两个面朝上的card，刚刚翻过来的是第三个card
                // 此时不可匹配
                
//                // 将所有的card扣回去
//                for flipDownIndex in cards.indices {
//                    cards[flipDownIndex].isFaceUp = false
//                }
//                // 只把刚刚选择的翻过来
//                cards[index].isFaceUp = true
                // 上面的代码，计算属性设置时已同时设置
                
                // 有且只有这个index是翻过来面朝上的
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        
    }
    
    
}


extension Collection {
    /** 有且只有一个 */
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
