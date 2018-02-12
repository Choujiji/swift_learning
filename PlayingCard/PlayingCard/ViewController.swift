//
//  ViewController.swift
//  PlayingCard
//
//  Created by mac on 2018/1/29.
//  Copyright © 2018年 jiji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /** 一副牌 */
    private var deck = PlayingCardDeck()
    
    /** 所有牌视图 */
    @IBOutlet private var cardViews: [PlayingCardView]!
    
    /** 所有面朝上的卡牌 */
    private var faceUpCardViews: [PlayingCardView] {
        // 面朝上 且 没有隐藏
        return cardViews.filter { $0.isFaceUp && !$0.isHidden }
    }
    
    /** 面朝上的牌是否匹配 */
    private var isFaceUpCardViewMatching: Bool {
        return faceUpCardViews.count == 2
        && faceUpCardViews[0].rank == faceUpCardViews[1].rank
        && faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    /** 动态动画对象 */
    private lazy var animator = UIDynamicAnimator(referenceView: view)
    /** 卡片仿真力 */
    private lazy var cardBehavior = CardBehavior(in: animator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** 牌数据 */
        var cards = [PlayingCard]()
        // 生成对应数量的牌数据
        for _ in 1...((cardViews.count + 1) / 2) {
            // 生成随机牌数据
            if let card = deck.draw() {
                print("\(card)")
                cards += [card, card]
            }
        }
        // 给视图PlayingCardView赋值
        for cardView in cardViews {
            cardView.isFaceUp = false
            // 随机取一张牌数据
            let card = cards.remove(at: cards.count.arc4random)
            // 赋值
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            // 添加点击手势
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flipCard(_:)))
            cardView.addGestureRecognizer(tapGesture)
            // 添加仿真动画
            cardBehavior.addItem(cardView)
        }
    }
    
    @objc
    func flipCard(_ gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            if let chosenCardView = gesture.view as? PlayingCardView {
//                chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                // 移除力（点击之后就移除所有的力）
                cardBehavior.removeItem(chosenCardView)
                
                // 使用动画的方式翻牌
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.6,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                    },
                    completion: { finished in
                        if self.isFaceUpCardViewMatching {
                            // 两张牌匹配
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    // 放大所有翻过来的牌
                                    self.faceUpCardViews.forEach {
                                        $0.transform = CGAffineTransform
                                            .identity
                                            .scaledBy(x: 3.0, y: 3.0)
                                    }
                                },
                                completion: { position in
                                    // 缩小并变透明
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            self.faceUpCardViews.forEach {
                                                $0.transform = CGAffineTransform
                                                    .identity
                                                    .scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                        },
                                        completion: { position in
                                            // 隐藏面朝上的牌，然后恢复原始状态
                                            self.faceUpCardViews.forEach {
                                                $0.isHidden = true
                                                // hidden后，下面的就看不出来了
                                                // 这里只是恢复默认状态
                                                $0.transform = .identity
                                                $0.alpha = 1
                                            }
                                        }
                                    )
                                }
                            )
                        } else if self.faceUpCardViews.count == 2 {
                            // 完成后，检查当前是否有2张牌翻过来
                            // 是，则都翻回去
                            self.faceUpCardViews.forEach{ cardView in
                                UIView.transition(
                                    with: cardView,
                                    duration: 0.6,
                                    options: [.transitionFlipFromLeft],
                                    animations: {
                                        cardView.isFaceUp = false
                                    },
                                    completion: { finished in
                                        // 由于点击后移除了相应的力，这里重新添加回来
                                        //（再次洗牌）
                                        self.cardBehavior.addItem(cardView)
                                    }
                                )
                            }
                            
                        } else {
                            // 只点了一张牌的情况
                            if !chosenCardView.isFaceUp {
                                // 点的牌翻过去了（即 点开一张牌，再点击扣上时）
                                // 把力加回来，重新洗牌
                                self.cardBehavior.addItem(chosenCardView)
                            }
                        }
                        
                    }
                )
            }
        default:
            break
        }
    }

}

extension CGFloat {
    var arc4random_float: CGFloat {
        return CGFloat(Double(arc4random()) / 0x100000000)
    }
}
