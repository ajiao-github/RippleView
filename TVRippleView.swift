//
//  TVRippleView.swift
//  RippleView
//
//  Created by ajiao on 2018/1/30.
//  Copyright © 2018年 ajiao. All rights reserved.
//
/*
 *********************************************************************************
 *
 * 🌟🌟🌟 新建交流QQ群：277157761 🌟🌟🌟
 *
 * 在您使用过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * Email : 2528982823@qq.com
 * GitHub: https://github.com/ajiao-github
 *
 *********************************************************************************
 */
import UIKit
enum TVRippleType:NSInteger {
    case TVRipple_Left
    case TVRipple_Right
}

class TVRippleView: UIView {

    static let UI_PAGE_HEIGHT = UIScreen.main.bounds.size.height
    static let UI_PAGE_WIDTH  = UIScreen.main.bounds.size.width

    static let Animation_Duration:CFTimeInterval = 1
    static let TipLabel_Width:CGFloat = 300
    static let TipLabel_Height:CGFloat = 80

    static let ArrowBgView_Width:CGFloat = 180
    static let ArrowBgView_Height:CGFloat = 70
    
    static let Arrow_BG_LR_Margin:CGFloat = 120
    static let Label_LR_Margin:CGFloat = 60
    static let Arrow_LR_Margin:CGFloat = 30
    static let Arrow_Center_Margin:CGFloat = 18
    static let Arrow_Height:CGFloat = 40
    static let Arrow_Width:CGFloat = 32

    
    static let Circle_Center:CGPoint = CGPoint(x: 100, y: TVRippleView.UI_PAGE_HEIGHT/2)//圆心位置(离position的间距,不代表方向)
    static let BG_Width:CGFloat = 1400*2//大圆半径
    static let BG_Height:CGFloat = 1400*2
    static let Bg_Radian:CGFloat = 428//大圆能看到的弧度宽
    static let Bg_TB_Margin:CGFloat = (TVRippleView.BG_Height - TVRippleView.UI_PAGE_HEIGHT)/2//大圆能看到的弧度宽 (1400-1080)/2=160

    static let Small_Circle_R:CGFloat = 100//小圆半径
    static let Medium_Circle_R:CGFloat = 600//中圆半径

    static let Small_Circle_Opacity:Float = 0.2//Opacity
    static let Mediun_Circle_Opacity:Float = 0.3//Opacity
    static let Large_Circle_ColorAlpha:CGFloat = 0.03//ColorAlpha

    private var isDismiss:Bool = false //动画未完成时需求想立马消失动画，避免还去执行一些不必要的操作
    var rippleType:TVRippleType = TVRippleType.TVRipple_Left//默认left
    private var blueEffectView:UIView!
    private var tipLabel:UILabel!
    private var arrorBgView:UIView!

    typealias CompleteAnimation = ()->Void
    var completeAnimation:CompleteAnimation?
    
    
    //MARK: 展示引导动画
    static func showGuideView(type:TVRippleType, atributeTipStr:NSMutableAttributedString, complete:@escaping CompleteAnimation) ->TVRippleView {
        let window = UIApplication.shared.windows.last
        let rippleView = TVRippleView()
        //加个遮罩
        rippleView.blueEffectView = TVRippleView.initMaskView()
        window?.addSubview(rippleView.blueEffectView)
        
        if type == .TVRipple_Left {
            rippleView.frame = CGRect(x: -(TVRippleView.BG_Width-TVRippleView.Bg_Radian), y: -(TVRippleView.BG_Height-TVRippleView.UI_PAGE_HEIGHT)/2, width: TVRippleView.BG_Width, height: TVRippleView.BG_Height)
        } else {
            rippleView.frame = CGRect(x: TVRippleView.UI_PAGE_WIDTH-TVRippleView.Bg_Radian, y: -(TVRippleView.BG_Height-TVRippleView.UI_PAGE_HEIGHT)/2, width: TVRippleView.BG_Width, height: TVRippleView.BG_Height)
        }
        rippleView.layer.cornerRadius = TVRippleView.BG_Width/2
        window?.addSubview(rippleView)
        
        rippleView.completeAnimation = complete
        rippleView.rippleType = type
        rippleView.isDismiss = false
        
        rippleView.backgroundColor = UIColor.rgba(red: 255, green: 255, blue: 255, alpha: TVRippleView.Large_Circle_ColorAlpha)
        rippleView.clipsToBounds = true
        rippleView.layer.masksToBounds = true
        
        rippleView.initArrorView()
        rippleView.initTipLabel(atributeStr: atributeTipStr)
        
        rippleView.perform(#selector(TVRippleView.addTriangle), with: rippleView, afterDelay:TVRippleView.Animation_Duration*1.0)

        rippleView.perform(#selector(TVRippleView.addTriangle), with: rippleView, afterDelay:TVRippleView.Animation_Duration*2.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + TVRippleView.Animation_Duration*3) {
            rippleView.dismiss(isAnimation: true)
        }
        return rippleView
    }
    
    //MARK: 展示上下视频切换动画
    static func showRipple(type:TVRippleType, atributeTipStr:NSMutableAttributedString, complete:@escaping CompleteAnimation) ->TVRippleView {
        let window = UIApplication.shared.windows.last
        let rippleView = TVRippleView()
        //加个遮罩
        rippleView.blueEffectView = TVRippleView.initMaskView()
        window?.addSubview(rippleView.blueEffectView)

        if type == .TVRipple_Left {
            rippleView.frame = CGRect(x: -(TVRippleView.BG_Width-TVRippleView.Bg_Radian), y: -(TVRippleView.BG_Height-TVRippleView.UI_PAGE_HEIGHT)/2, width: TVRippleView.BG_Width, height: TVRippleView.BG_Height)
        } else {
            rippleView.frame = CGRect(x: TVRippleView.UI_PAGE_WIDTH-TVRippleView.Bg_Radian, y: -(TVRippleView.BG_Height-TVRippleView.UI_PAGE_HEIGHT)/2, width: TVRippleView.BG_Width, height: TVRippleView.BG_Height)
        }
        rippleView.layer.cornerRadius = TVRippleView.BG_Width/2
        window?.addSubview(rippleView)

        rippleView.completeAnimation = complete
        rippleView.rippleType = type
        rippleView.isDismiss = false

        rippleView.backgroundColor = UIColor.clear
        rippleView.clipsToBounds = true
        rippleView.layer.masksToBounds = true

        rippleView.addRippleLayer(beginRect: rippleView.makeBeginRect(), endRect: rippleView.makeEndRect(), opacity: TVRippleView.Small_Circle_Opacity)
    
        rippleView.perform(#selector(TVRippleView.initArrorView), with: atributeTipStr, afterDelay:TVRippleView.Animation_Duration*0.2)
        
        rippleView.perform(#selector(TVRippleView.addTriangle), with: rippleView, afterDelay:TVRippleView.Animation_Duration*1.0)
            
        rippleView.perform(#selector(TVRippleView.initTipLabel(atributeStr:)), with: atributeTipStr, afterDelay:TVRippleView.Animation_Duration*0.3)

        DispatchQueue.main.asyncAfter(deadline: .now() + TVRippleView.Animation_Duration*0.4) {
            rippleView.doShowBgViewAnimation()

            rippleView.addRippleLayer(beginRect: rippleView.makeBeginRect(), endRect: rippleView.makeEndRect(), opacity: TVRippleView.Mediun_Circle_Opacity)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TVRippleView.Animation_Duration*2.0) {
            rippleView.dismiss(isAnimation: true)
        }
        
        return rippleView
    }
    
    //MARK: 初始化遮罩view
    static func initMaskView() -> UIView {
        let maskView = UIView()
        maskView.frame = CGRect(x: 0, y: 0, width: TVRippleView.UI_PAGE_WIDTH, height: TVRippleView.UI_PAGE_HEIGHT)
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.3
        return maskView
    }
    
    //MARK: 开始小圆的圆心位置以及半径
    func makeBeginRect() -> CGRect {
        var beginRect =  CGRect(x: 0, y: 0, width: 0, height: 0)
        if rippleType == .TVRipple_Left {
            //左边
            //x的值是圆心x位置减去半径大小
            beginRect = CGRect(x: TVRippleView.Circle_Center.x - TVRippleView.Small_Circle_R, y: -TVRippleView.Small_Circle_R, width: TVRippleView.Small_Circle_R*2, height: TVRippleView.Small_Circle_R*2)//半径是100，圆心在坐标系统中的0,-100(相对position位置，把position那里看成是0，0位置)

        } else if rippleType == .TVRipple_Right {
            //右边
            //x的值是圆心x位置加上半径大小
            beginRect = CGRect(x:-(TVRippleView.Circle_Center.x + TVRippleView.Small_Circle_R), y: -TVRippleView.Small_Circle_R, width: TVRippleView.Small_Circle_R*2, height: TVRippleView.Small_Circle_R*2)//半径是100，圆心在坐标系统中的-200,-100(相对position位置，把position那里看成是0，0位置)
        }
        return beginRect
    }
    
    //MARK: 开始中圆的圆心位置以及半径
    func makeEndRect() -> CGRect {
        var endRect =  CGRect(x: 0, y: 0, width: 0, height: 0)
        if rippleType == .TVRipple_Left {
            //左边
            //x的值是圆心x位置减去半径大小
            endRect = CGRect(x: TVRippleView.Circle_Center.x - TVRippleView.Medium_Circle_R, y: -TVRippleView.Medium_Circle_R, width: TVRippleView.Medium_Circle_R*2, height: TVRippleView.Medium_Circle_R*2)//(相对position位置，把position那里看成是0，0位置)

        } else if rippleType == .TVRipple_Right {
            //右边
            //x的值是圆心x位置加上半径大小
            endRect = CGRect(x:-(TVRippleView.Circle_Center.x + TVRippleView.Medium_Circle_R), y: -TVRippleView.Medium_Circle_R, width: TVRippleView.Medium_Circle_R*2, height: TVRippleView.Medium_Circle_R*2)//(相对position位置，把position那里看成是0，0位置)
        }
        return endRect
    }
    
    //MARK: 背景色透明度加个动画
    func doShowBgViewAnimation() {
        if self.isDismiss {
            return
        }
        UIView.animate(withDuration: 0.35) {
            self.backgroundColor = UIColor.rgba(red: 255, green: 255, blue: 255, alpha: TVRippleView.Large_Circle_ColorAlpha)
        }
    }
    
    //MARK: tip文案
    @objc func initTipLabel(atributeStr:NSMutableAttributedString) {
        if self.isDismiss {
            return
        }
        tipLabel = UILabel()
        if rippleType == .TVRipple_Left {
            tipLabel.frame = CGRect(x: self.frame.size.width - TVRippleView.Bg_Radian + TVRippleView.Label_LR_Margin, y: TVRippleView.Bg_TB_Margin+TVRippleView.UI_PAGE_HEIGHT/2+30, width: TVRippleView.TipLabel_Width, height: TVRippleView.TipLabel_Height)
        } else if rippleType == .TVRipple_Right {
            tipLabel.frame = CGRect(x: TVRippleView.Bg_Radian - TVRippleView.TipLabel_Width - TVRippleView.Label_LR_Margin, y: TVRippleView.Bg_TB_Margin+TVRippleView.UI_PAGE_HEIGHT/2+30, width: TVRippleView.TipLabel_Width, height: TVRippleView.TipLabel_Height)
        }
        //文字添加阴影
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 6.0
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.6)
        atributeStr.addAttribute(NSAttributedStringKey.shadow, value: shadow, range: NSMakeRange(0, atributeStr.length))
        tipLabel.backgroundColor = UIColor.clear
        tipLabel.textColor = UIColor.white
        tipLabel.numberOfLines = 2
        tipLabel.attributedText = atributeStr
        tipLabel.textAlignment = .center
        self.addSubview(tipLabel)
    }
    
    //MARK: 三角形view
    @objc func initArrorView() {
        if self.isDismiss {
            return
        }
        arrorBgView = UIView()
        if rippleType == .TVRipple_Left {
            arrorBgView.frame = CGRect(x: self.frame.size.width - TVRippleView.Bg_Radian + TVRippleView.Arrow_BG_LR_Margin, y: TVRippleView.Bg_TB_Margin+TVRippleView.UI_PAGE_HEIGHT/2-50, width: TVRippleView.ArrowBgView_Width, height: TVRippleView.ArrowBgView_Height)
        } else if rippleType == .TVRipple_Right {
            arrorBgView.frame = CGRect(x: TVRippleView.Bg_Radian - TVRippleView.ArrowBgView_Width - TVRippleView.Arrow_BG_LR_Margin, y: TVRippleView.Bg_TB_Margin+TVRippleView.UI_PAGE_HEIGHT/2-50, width: TVRippleView.ArrowBgView_Width, height: TVRippleView.ArrowBgView_Height)
        }
        arrorBgView.backgroundColor = UIColor.clear
        self.addSubview(arrorBgView)
        
        //在arrorBgView画三角形
        addTriangle()
    }
    
    //MARK: 画三角形并且添加动画
    @objc func addTriangle() {
        if self.isDismiss {
            return
        }
        //动画1，时间成等差数列
        DispatchQueue.main.asyncAfter(deadline: .now() + TVRippleView.Animation_Duration*0.2) {
            if self.rippleType == .TVRipple_Right {
                let leftTopPoint = CGPoint(x: TVRippleView.Arrow_LR_Margin, y: (TVRippleView.ArrowBgView_Height - TVRippleView.Arrow_Height)/2)
                let leftBottmPoint = CGPoint(x: TVRippleView.Arrow_LR_Margin, y: (TVRippleView.ArrowBgView_Height - TVRippleView.Arrow_Height)/2 + TVRippleView.Arrow_Height)
                let rightPoint = CGPoint(x: TVRippleView.Arrow_LR_Margin + TVRippleView.Arrow_Width, y: TVRippleView.ArrowBgView_Height/2)
                self.addOpacityAnimation(leftTopPoint: leftTopPoint, leftBottmPoint:leftBottmPoint, rightPoint: rightPoint)
            } else if self.rippleType == .TVRipple_Left {
                let rightTopPoint = CGPoint(x: TVRippleView.ArrowBgView_Width - TVRippleView.Arrow_LR_Margin, y: (TVRippleView.ArrowBgView_Height - TVRippleView.Arrow_Height)/2)
                let rightBottmPoint = CGPoint(x: TVRippleView.ArrowBgView_Width - TVRippleView.Arrow_LR_Margin, y: (TVRippleView.ArrowBgView_Height - TVRippleView.Arrow_Height)/2 + TVRippleView.Arrow_Height)
                let leftPoint = CGPoint(x: TVRippleView.ArrowBgView_Width - TVRippleView.Arrow_LR_Margin - TVRippleView.Arrow_Width, y: TVRippleView.ArrowBgView_Height/2)
                self.addOpacityAnimation(leftTopPoint: rightTopPoint, leftBottmPoint:rightBottmPoint, rightPoint: leftPoint)
            }
        }
        
        //动画2
        DispatchQueue.main.asyncAfter(deadline: .now() + TVRippleView.Animation_Duration*0.4) {
            if self.rippleType == .TVRipple_Right {
                let leftTopPoint = CGPoint(x: TVRippleView.Arrow_LR_Margin + TVRippleView.Arrow_Width + TVRippleView.Arrow_Center_Margin , y: (TVRippleView.ArrowBgView_Height - TVRippleView.Arrow_Height)/2)
                let leftBottmPoint = CGPoint(x: TVRippleView.Arrow_LR_Margin + TVRippleView.Arrow_Width + TVRippleView.Arrow_Center_Margin, y: (TVRippleView.ArrowBgView_Height - TVRippleView.Arrow_Height)/2 + TVRippleView.Arrow_Height)
                let rightPoint = CGPoint(x: TVRippleView.Arrow_LR_Margin + TVRippleView.Arrow_Width * 2 + TVRippleView.Arrow_Center_Margin, y: TVRippleView.ArrowBgView_Height/2)
                self.addOpacityAnimation(leftTopPoint: leftTopPoint, leftBottmPoint:leftBottmPoint, rightPoint: rightPoint)
            } else if self.rippleType == .TVRipple_Left {
                let rightTopPoint = CGPoint(x: TVRippleView.ArrowBgView_Width - TVRippleView.Arrow_LR_Margin - TVRippleView.Arrow_Width - TVRippleView.Arrow_Center_Margin, y: (TVRippleView.ArrowBgView_Height - TVRippleView.Arrow_Height)/2)
                let rightBottmPoint = CGPoint(x: TVRippleView.ArrowBgView_Width - TVRippleView.Arrow_LR_Margin - TVRippleView.Arrow_Width - TVRippleView.Arrow_Center_Margin, y: (TVRippleView.ArrowBgView_Height - TVRippleView.Arrow_Height)/2 + TVRippleView.Arrow_Height)
                let leftPoint = CGPoint(x: TVRippleView.ArrowBgView_Width - TVRippleView.Arrow_LR_Margin - TVRippleView.Arrow_Width * 2 - TVRippleView.Arrow_Center_Margin, y: TVRippleView.ArrowBgView_Height/2)
                self.addOpacityAnimation(leftTopPoint: rightTopPoint, leftBottmPoint:rightBottmPoint, rightPoint: leftPoint)
            }
        }
        //动画3
        DispatchQueue.main.asyncAfter(deadline: .now() + TVRippleView.Animation_Duration*0.6) {
            if self.rippleType == .TVRipple_Right {
                let leftTopPoint = CGPoint(x: TVRippleView.Arrow_LR_Margin + TVRippleView.Arrow_Width * 2 + TVRippleView.Arrow_Center_Margin * 2 , y: (TVRippleView.ArrowBgView_Height - TVRippleView.Arrow_Height)/2)
                let leftBottmPoint = CGPoint(x: TVRippleView.Arrow_LR_Margin + TVRippleView.Arrow_Width * 2 + TVRippleView.Arrow_Center_Margin * 2, y: (TVRippleView.ArrowBgView_Height - TVRippleView.Arrow_Height)/2 + TVRippleView.Arrow_Height)
                let rightPoint = CGPoint(x: TVRippleView.Arrow_LR_Margin + TVRippleView.Arrow_Width * 3 + TVRippleView.Arrow_Center_Margin * 2, y: TVRippleView.ArrowBgView_Height/2)
                self.addOpacityAnimation(leftTopPoint: leftTopPoint, leftBottmPoint:leftBottmPoint, rightPoint: rightPoint)
            } else if self.rippleType == .TVRipple_Left {
                let rightTopPoint = CGPoint(x: TVRippleView.ArrowBgView_Width - TVRippleView.Arrow_LR_Margin - TVRippleView.Arrow_Width * 2 - TVRippleView.Arrow_Center_Margin * 2, y: (TVRippleView.ArrowBgView_Height - TVRippleView.Arrow_Height)/2)
                let rightBottmPoint = CGPoint(x: TVRippleView.ArrowBgView_Width - TVRippleView.Arrow_LR_Margin - TVRippleView.Arrow_Width * 2 - TVRippleView.Arrow_Center_Margin * 2, y: (TVRippleView.ArrowBgView_Height - TVRippleView.Arrow_Height)/2 + TVRippleView.Arrow_Height)
                let leftPoint = CGPoint(x: TVRippleView.ArrowBgView_Width - TVRippleView.Arrow_LR_Margin - TVRippleView.Arrow_Width * 3 - TVRippleView.Arrow_Center_Margin * 2, y: TVRippleView.ArrowBgView_Height/2)
                self.addOpacityAnimation(leftTopPoint: rightTopPoint, leftBottmPoint:rightBottmPoint, rightPoint: leftPoint)
            }
        }
    }
    
    //MARK: 根据三个坐标画个三角形
    func addOpacityAnimation(leftTopPoint:CGPoint, leftBottmPoint:CGPoint, rightPoint:CGPoint) {
        if self.isDismiss {
            return
        }
        //layer
        let triangleLayer = CAShapeLayer()
        triangleLayer.strokeColor = UIColor.white.cgColor
        triangleLayer.lineWidth = 1.5
        triangleLayer.fillColor = UIColor.white.cgColor
        if self.arrorBgView != nil {
            self.arrorBgView.layer.addSublayer(triangleLayer)
        }
        //三角形1
        let trianglePath = UIBezierPath()
        trianglePath.move(to: leftTopPoint)
        trianglePath.addLine(to: leftBottmPoint)
        trianglePath.addLine(to: rightPoint)
        UIColor.magenta.setFill()
        trianglePath.fill()
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.opacity = 0.0
        //动画
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(value: 0.8)
        opacityAnimation.toValue = NSNumber(value: 0.3)
        opacityAnimation.duration = 0.4
        triangleLayer.add(opacityAnimation, forKey: "aa")//key值无所谓，随便写
    }
    
    //MARK: 动画消失
    func dismiss(isAnimation:Bool) {
        self.isDismiss = true
        if self.superview != nil {
            if !isAnimation {
                removeAllView()
                return
            }
            //添加个消失的动画
            UIView.animate(withDuration: 0.1, animations: {
                if self.layer.sublayers != nil && (self.layer.sublayers?.count)! > 0 {
                    for layer in self.layer.sublayers! {
                        layer.opacity = 0.05
                    }
                }
            }, completion: { (flag) in
                if self.layer.sublayers != nil && (self.layer.sublayers?.count)! > 0 {
                    for layer in self.layer.sublayers! {
                        layer.opacity = 0.0
                    }
                }
                self.removeAllView()
            })
        }
    }
    
    //MARK: removeAllView
    private func removeAllView() {
        self.removeAllSubLayers()
        if self.blueEffectView != nil {
            self.blueEffectView.removeFromSuperview()
        }
        self.removeFromSuperview()
        self.layer.removeAllAnimations()
        if self.completeAnimation != nil {
            self.completeAnimation!()
        }
    }
    
    //MARK: removeAllSubLayers
    private func removeAllSubLayers() {
        if self.layer.sublayers != nil && (self.layer.sublayers?.count)! > 0 {
            for layer in self.layer.sublayers! {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    //MARK: 根据两个圆的位置和半径画圆，并且添加透明度变化的动画
    func addRippleLayer(beginRect:CGRect, endRect:CGRect,opacity:Float) {
        if self.isDismiss {
            return
        }
        let rippleLayer = CAShapeLayer()
        if rippleType == .TVRipple_Left {
            
            //160 = (self.frame.size.height - TVRippleView.UI_PAGE_HEIGHT)/2
            //972 = self.frame.size.width - TVRippleView.Bg_Radian
            rippleLayer.position = CGPoint(x: self.frame.size.width - TVRippleView.Bg_Radian, y: (self.frame.size.height - TVRippleView.UI_PAGE_HEIGHT)/2 + TVRippleView.Circle_Center.y)//左边顶点，相对子layer的位置
        } else if rippleType == .TVRipple_Right {
            rippleLayer.position = CGPoint(x: TVRippleView.Bg_Radian, y: TVRippleView.Bg_TB_Margin + TVRippleView.Circle_Center.y)//右边顶点，相对子layer的位置
        }
        rippleLayer.strokeColor = UIColor.white.cgColor
        rippleLayer.lineWidth = 1.5
        rippleLayer.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(rippleLayer)
        
        //把tiplabel放顶上
        if tipLabel != nil {
            self.bringSubview(toFront: tipLabel)
        }
        
        //addRippleAnimation
        let beginPath = UIBezierPath(ovalIn:beginRect)
        let endPath = UIBezierPath(ovalIn: endRect)
        rippleLayer.path = endPath.cgPath
        rippleLayer.opacity = opacity
        
        let rippleAnimation = CABasicAnimation(keyPath: "path")
        rippleAnimation.fromValue = beginPath.cgPath
        rippleAnimation.toValue = endPath.cgPath
        rippleAnimation.duration = TVRippleView.Animation_Duration
        rippleLayer.add(rippleAnimation, forKey: "")
    }
}
