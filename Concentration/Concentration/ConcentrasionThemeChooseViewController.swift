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
    
    /** 当前的splitVC的detailVC是否是ConcentrationVC */
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    /** 之前的ConcentrationVC（用于在iPhone上对push到的cvc进行强保留，防止被释放，用来保存
        游戏状态） */
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    /** 切换主题 */
    @IBAction func segueToAction(_ sender: Any) {
//        performSegue(withIdentifier: "Choose Theme", sender: sender)

        // 当前已经在ConcentrationViewController中，则只切换主题
        // 否则才创建新的
        if let cvc = splitViewDetailConcentrationViewController {
            // 获取点击按钮对应的theme数据
            if let themeName = (sender as? UIButton)?.currentTitle,
                let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            // 设置theme
            if let themeName = (sender as? UIButton)?.currentTitle,
                let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            // 由于发起navigation跳转是UIButton点击事件发起，
            // 所以sender理论上是UIButton对象
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    // 保留当前cvc
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }

}
