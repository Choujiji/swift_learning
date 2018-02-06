//
//  ConcentrasionThemeChooseViewController.swift
//  Concentration
//
//  Created by mac on 2018/2/5.
//  Copyright © 2018年 jiji. All rights reserved.
//

import UIKit

class ConcentrasionThemeChooseViewController: UIViewController {

//     MARK: - Navigation
    
    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🎱🏓",
        "Animals": "🐶🐱🐹🦊🐻🐼🐵🐷",
        "Faces": "😀😅😍😜😚😎🤡😱"
    ]

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            // 由于发起navigation跳转是UIButton点击事件发起，
            // 所以sender理论上是UIButton对象
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                }
            }
        }
    }

}
