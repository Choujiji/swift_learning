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


}

