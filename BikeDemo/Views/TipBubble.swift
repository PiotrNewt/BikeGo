//
//  TipBubble.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/4/20.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit

class TipBubble: UIView {
    
    var TipContent: String = ""
    let TipLable = UILabel()
    var BubbackgroundColor = UIColor.colorFromHex(hexString: "#000000").withAlphaComponent(0.6)
    var TipTextColor = UIColor.white
    
    func layout() -> CGRect {
        TipLable.text = TipContent
        TipLable.textColor = TipTextColor
        TipLable.font = UIFont.systemFont(ofSize: 13)
        let textMaxSize = CGSize(width: 240, height: CGFloat(MAXFLOAT))
        let textLabelSize = self.textSize(text: TipContent, font: TipLable.font, maxSize: textMaxSize)
        
        TipLable.frame.origin.x = 10
        TipLable.frame.origin.y = 10
        TipLable.frame.size = textLabelSize
        
        self.addSubview(TipLable)
        let height = TipLable.frame.height
        let width = TipLable.frame.width
        
        let frame = CGRect(x: (UIScreen.main.bounds.width - width) / 2 - 10, y: 40, width: width + 20, height: height + 20)
        self.backgroundColor = BubbackgroundColor
        self.layer.cornerRadius = height - 5
        self.layer.masksToBounds = true
        return frame
    }
    
    func textSize(text: String, font: UIFont, maxSize: CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: font], context: nil).size
    }
    
    func show(dalay: Double) {
        //
        let showFrame = layout()
        let start_endFrame = CGRect(x: showFrame.origin.x, y: -10, width: showFrame.width, height: showFrame.height)
        self.frame = start_endFrame
        self.alpha = 0
        //
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.frame = showFrame
            self.alpha = 1
        }, completion: {(finish: Bool) -> Void in
            //
            UIView.animate(withDuration: 0.25, delay: dalay, options: .curveEaseOut, animations: {() -> Void in
                self.frame = start_endFrame
                self.alpha = 0
            }, completion: {(finish: Bool) -> Void in
                    self.removeFromSuperview()
            })
        })
        
    }
    

}
