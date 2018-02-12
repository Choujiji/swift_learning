//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by mac on 2018/2/10.
//  Copyright © 2018年 jiji. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    /** 碰撞行为对象 */
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        // 设置参照视图的边框也可以进行碰撞（这里就是self.view）
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    /** 自定义仿真对象行为 */
    lazy var itemBahavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0   // 弹力（1.0位正常，大于则碰撞后增加，小于会减少）
        behavior.resistance = 0.0   // 阻力
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem) {
        let pushBehavior = UIPushBehavior(
            items: [item],
            mode: .instantaneous    // 瞬时力
        )
        pushBehavior.angle = (2 * CGFloat.pi).arc4random_float
        pushBehavior.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random_float
        // 执行推力动画期间的行为
        pushBehavior.action = { [unowned pushBehavior, weak self] in
           // 移除此力behavior对象
            self?.removeChildBehavior(pushBehavior)
        }
        // 将自身添加到父behavior中
        addChildBehavior(pushBehavior)
    }
    
    /** 把力添加到指定项目上 */
    func addItem(_ item: UIDynamicItem) {
        // 给所有的behavior力对象添加item
        collisionBehavior.addItem(item)
        itemBahavior.addItem(item)
        push(item)
    }
    
    /** 把力从指定项目上移除 */
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBahavior.removeItem(item)
    }
    
    override init() {
        super.init()
        
        // 合并到一起，让外部UIDynamicAnimator对象直接添加self
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBahavior)
    }
    
    /** 便捷方法：传入仿真动画对象 */
    convenience init(in animator: UIDynamicAnimator) {
        // 调用真正init
        self.init()
        // 动画对象直接添加力
        animator.addBehavior(self)
    }
}
