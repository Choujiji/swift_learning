//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by mac on 2018/2/2.
//  Copyright © 2018年 jiji. All rights reserved.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    /** 级别 */
    @IBInspectable
    var rank: Int = 11 {
        didSet {
            setNeedsDisplay()   // 重绘界面
            setNeedsLayout()    // 重新布局
        }
    }
    /** 花色 */
    @IBInspectable
    var suit: String = "❤️" {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    /** 面朝上 */
    @IBInspectable
    var isFaceUp: Bool = true {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    /** 尺寸比例 */
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @objc
    func adjustFaceCardScale(byHandlingGestureRecognizedBy gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .changed, .ended:
            faceCardScale *= gesture.scale
            // 重置手势的scale
            gesture.scale = 1.0
        default:
            break
        }
    }
    
    /** 居中的属性文字 */
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        // 字号设置
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        //  根据用户设置进行动态字号缩放
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        // 段落排版设置
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center  // 居中
        
        // 返回属性文字对象
        return NSAttributedString(
            string: string,
            attributes: [
                .paragraphStyle : paragraphStyle,
                .font: font
            ]
        )
    }
    
    /** 边角显示文字 */
    private var cornerString: NSAttributedString {
        // rankString在下面的extension里，用于返回对应的字符串
        return centeredAttributedString(rankString + "\n" + suit, fontSize: cornerFontSize)
    }
    
    /** 左上角标签
     *  注意：由于属性是在self初始化之前就初始化完成，所以此时无法直接调用self的实例方法来初始
        化属性。这里使用lazy将属性延迟到调用时再初始化（调用时已经存在self）
     
     */
    private lazy var upperLeftCornerLabel: UILabel = createCornerLabel()
    /** 右下角标签 */
    private lazy var lowerRightCornerLabel: UILabel = createCornerLabel()
    
    /** 创建边角标签 */
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    /** 配置边角标签 */
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero  // 设为0，下面sizeToFit会在宽和高上自动设置尺寸
        label.sizeToFit()   // 根据文字尺寸自动设置label的尺寸（在所有View中都可以，根据子视图的尺寸自动设置父视图的尺寸，以便完全容下子视图）
        
        label.isHidden = !isFaceUp  // 面朝下时，不显示
    }
    
    /** iOS接口环境改变回调（如用户调整系统字号等） */
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    /** 重新布局（调用setNeedsLayout时，自动调用） */
    override func layoutSubviews() {
        super.layoutSubviews()
        // 1.左上角文字
        // 配置文字样式
        configureCornerLabel(upperLeftCornerLabel)
        // 设置位置
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        // 2.右下角文字
        configureCornerLabel(lowerRightCornerLabel)
        
        // 倒置文字分两步：1.旋转  2.平移（使用仿射变换矩阵）
        // 平移原因是，默认锚点是在自身原点，左上角，旋转后需要平移出自身尺寸来回到原位置
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .rotated(by: CGFloat.pi)
            .translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height)

        // 位置分两步：先放到右下角，然后1.减去自身尺寸，2.减去delta值
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
    }
    
    /** 重绘视图（调用setNeedsDisplay时，自动调用） */
    override func draw(_ rect: CGRect) {
//        // 使用上下文（context）对象画圆【有问题，无论是先fill或是先stroke，context只会操作一次，第二个就不起作用了】
//        if let context = UIGraphicsGetCurrentContext() {
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
//            context.setLineWidth(5.0)
//            UIColor.green.setFill()
//            context.fillPath()
//            UIColor.red.setStroke()
//            context.strokePath()
//
//        }
        
//        // 使用贝塞尔曲线类画圆【完美，UIBezierPath对象可以反复设置path的样式】
//        let path = UIBezierPath()
//        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
//        path.lineWidth = 5.0
//        UIColor.green.setFill()
//        UIColor.red.setStroke()
//        path.fill()
//        path.stroke()
        
        
        // 绘制全屏带圆角的牌
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        UIColor.white.setFill()
        roundedRect.fill()
        
        
        if isFaceUp {
            // 面朝上
            if let faceCardImage = UIImage(named: rankString + suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            } else {
                // 绘制普通花色
            }
        } else {
            // 面朝下
            if let cardBackImage = UIImage(named: "backImage", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)
            }
        }
        
    }

}

// 一些比例数值定义
extension PlayingCardView {
    /** 尺寸比例 */
    private struct SizeRatio {
        /** 边角字号相对于bounds高度的比例 */
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        /** 边角半径相对于bounds高度的比例 */
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        /** 边角偏移相对于边角半径的比例 */
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        /** 卡牌面上图片尺寸相对于bounds尺寸的比例 */
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
        
    }
    
    /** 边角半径 */
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    /** 边角偏移 */
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    /** 边角字号 */
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    /** 获取等级字符串 */
    private var rankString: String {
        // 传入rank属性，返回对应字符串（用于上面拼合显示字符串）
        switch rank {
        case 1:
            return "A"
        case 2...10:
            return String(rank)
        case 11:
            return "J"
        case 12:
            return "Q"
        case 13:
            return "K"
        default:
            return "?"
        }
    }
}

// 一些rect变量定义
extension CGRect {
    /** 左半部 */
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width / 2, height: height)
    }
    
    /** 右半部 */
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width / 2, height: height)
    }
    
    /** 内嵌尺寸（内边距） */
    func inset(by size: CGSize) -> CGRect {
        // dx和dy为变化量（正值为减小，负值为增大）
        return insetBy(dx: size.width, dy: size.height) // 中心点不变，宽高改变
    }
    
    /** 修改尺寸 */
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)   // 原点不变，尺寸改变返回
    }
    
    /** 缩放（中心点不变，尺寸按比例修改） */
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

// 一些point变量定义
extension CGPoint {
    /** 偏移指定点 */
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}
