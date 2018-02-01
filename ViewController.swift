//
//  ViewController.swift
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

class ViewController: UIViewController {
    var isShowRippleAniamtion = false
    var rippleView:TVRippleView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        if isShowRippleAniamtion {
            return
        }
        isShowRippleAniamtion = true
        
        switch sender.tag {
        case 100:
            print("")
            let atrbuteStr = NSMutableAttributedString(string: "輕擊兩次【右鍵】\n切換下一個视频")
            atrbuteStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 32), range: NSMakeRange(0, atrbuteStr.length))
            atrbuteStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.init(hexString: "#FFB400") ?? UIColor.white, range: NSRange.init(location: 2, length: 6))
            rippleView = TVRippleView.showGuideView(type: .TVRipple_Right, atributeTipStr:atrbuteStr) {
                self.isShowRippleAniamtion = false
            }
        
        case 101:
            print("")
            let atrbuteStr = NSMutableAttributedString(string: "上一個视频\n")
            atrbuteStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 32), range: NSMakeRange(0, atrbuteStr.length))
            atrbuteStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: atrbuteStr.length))
            rippleView = TVRippleView.showRipple(type: .TVRipple_Left, atributeTipStr:atrbuteStr) {
                self.isShowRippleAniamtion = false
              
            }
        
        case 102:
            print("")
            let atrbuteStr = NSMutableAttributedString(string: "下一個视频\n")
            atrbuteStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 32), range: NSMakeRange(0, atrbuteStr.length))
            atrbuteStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange.init(location: 0, length: atrbuteStr.length))
            rippleView = TVRippleView.showRipple(type: .TVRipple_Right, atributeTipStr:atrbuteStr) {
                self.isShowRippleAniamtion = false
            }
        
        default:
            print("")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

