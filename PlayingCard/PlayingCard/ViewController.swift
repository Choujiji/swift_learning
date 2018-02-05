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
    var deck = PlayingCardDeck()
    
    @IBOutlet weak var playingCardView: PlayingCardView! {
        didSet {
            // 添加清扫手势
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]
            playingCardView.addGestureRecognizer(swipe)
            
            // 添加缩放手势
            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(playingCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
            playingCardView.addGestureRecognizer(pinch)
        }
    }
    
    /** 单击手势回调 */
    @IBAction func filpCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            playingCardView.isFaceUp = !playingCardView.isFaceUp
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 随机抽出10张牌，输出
        for _ in 1...10 {
            if let card = deck.draw() {
                print("\(card)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc
    func nextCard() {
        // 获取一张牌数据对象，赋值给view
        if let card = deck.draw() {
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
        }
    }

}

