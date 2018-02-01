//
//  UIColor+InitExtention.swift
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

extension UIColor {
    
    static public func rgba(red: UInt8, green: UInt8, blue: UInt8, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(Float(red) / 255.0), green: CGFloat(Float(green) / 255.0), blue: CGFloat(Float(blue) / 255.0), alpha:alpha)
    }
    
    static public func rgb(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) -> UIColor {
        return UIColor(red: CGFloat(Float(red) / 255.0), green: CGFloat(Float(green) / 255.0), blue: CGFloat(Float(blue) / 255.0), alpha: 1)
    }
    
    
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
