//
//  ViewController.swift
//  Concentration
//
//  Created by mac on 2017/11/27.
//  Copyright © 2017年 jiji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberPairsOfCards: numberOfPairsOfCards)  // lazy - 当访问时，才初始化

    // 简单的计算属性（这里是只读）
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    var flipCount = 0 {
        didSet {
//            flipCountLabel.text = "Flips: \(flipCount)"
            // NSAttributeString
            updateFlipCountLabel()
        }
    }

    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            print("cardNumber = \(cardNumber)")
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("not in cardButtons...")
        }
    }
    
    /** 更新文字显示 */
    func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.orange
        ]
        let str = NSAttributedString(string: "Flip: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = str
    }
    
    func updateViewFromModel() {
//        for index in 0 ..< cardButtons.count {
        for index in cardButtons.indices {
            // 根据index取出对应索引的button和card实例
            let button = cardButtons[index] // 对应index的按钮
            let card = game.cards[index]    // 对应index的card实例
            // button样式  与  card数据  状态一致（数据驱动界面更新）
            if card.isFaceUp == true {
                // 按钮也需要翻过来
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            } else {
                // 按钮也需要扣上（若已经匹配上，则隐藏该按钮）
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.99483639, green: 0.5957265496, blue: 0.1807449758, alpha: 0) : #colorLiteral(red: 0.99483639, green: 0.5957265496, blue: 0.1807449758, alpha: 1)
            }
        }
    }
    
//    var emojiChoices = ["🎃", "👻", "😈", "🤖", "💋", "😸", "👍", "😬"]
    var emojiChoices = "🎃👻😈🤖💋😸👍😬"
    
    var emoji = [Card: String]() // Dictionary
    
    /** 根据card实例返回emoji */
    func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            // 随机添加进一个emoji
//            let randomIndex = (emojiChoices.count).getRandomIndex()
            let randomIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.getRandomIndex())
            // 添加进字典去的数据不可再次加入，所以直接在数组中移除该emoji
            emoji[card] = String(emojiChoices.remove(at: randomIndex))
        }
        
//        if emoji[card.identifier] != nil {
//            return emoji[card.identifier]!
//        }
//        return "?"
        // optional ?? xx（有值则解绑返回，否则返回预设值）
        return emoji[card] ?? "?"
    }
}


extension Int {
    func getRandomIndex() -> Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

