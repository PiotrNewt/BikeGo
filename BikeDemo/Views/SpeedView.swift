//
//  SpeedView.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/3/30.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit

@IBDesignable
class SpeedView: UIView {
    
    let outCircleLayer = CAShapeLayer()  //绘制立方贝塞尔曲线图层.外圆形
    let interCircleLayer = CAShapeLayer()  //内圆
    let gradientLayer = CAGradientLayer()  //绘制渐变色图层
    
    //渐变颜色
    struct Constants {
        struct ColorPalette {
            static let purple = UIColor.colorFromHex(hexString: "#8D37EE")
            static let bluple = UIColor.colorFromHex(hexString: "#7238F5")
            static let blue = UIColor.colorFromHex(hexString: "#5939FB")
        }
    }
    
    var speedValue: CGFloat = 0 {
        didSet {
            //执行进度曲线的动画
            speedAnimation()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //加载曲线
        setupLayer()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        //加载曲线
        setupLayer()
    }
    
    func setupLayer() -> Void{
        //外圆
        outCircleLayer.position = CGPoint.zero
        outCircleLayer.lineWidth = 6.0
        outCircleLayer.fillColor = UIColor.clear.cgColor
        outCircleLayer.strokeColor = UIColor.black.cgColor
        outCircleLayer.strokeStart = 0
        outCircleLayer.strokeEnd = 0
        
        //轴心圆
        interCircleLayer.position = CGPoint.zero
        interCircleLayer.lineWidth = 3.0
        interCircleLayer.fillColor = UIColor.clear.cgColor
        interCircleLayer.strokeColor = UIColor.colorFromHex(hexString: "#373E37").cgColor
        
        let outRadius = CGFloat(self.bounds.height / 2) - outCircleLayer.lineWidth / 2 //半径
        let interRadius = CGFloat(self.bounds.height / 2) - interCircleLayer.lineWidth
        let wStartAngle = CGFloat(13 * Double.pi / 16) //开始角度
        let WEndAngle = CGFloat(3 * Double.pi / 16) //结束角度
        let width = self.bounds.width
        let height = self.bounds.height
        let modelCenter = CGPoint(x: width / 2, y: height / 2)  //圆心
        
        let outCircle = UIBezierPath(arcCenter: modelCenter, radius: outRadius, startAngle: wStartAngle, endAngle: WEndAngle, clockwise: true)
        let interCircle = UIBezierPath(arcCenter: modelCenter, radius: interRadius, startAngle: wStartAngle, endAngle: WEndAngle, clockwise: true)
        
        outCircleLayer.path = outCircle.cgPath
        interCircleLayer.path = interCircle.cgPath
        
        self.layer.addSublayer(outCircleLayer)
        self.layer.addSublayer(interCircleLayer)
        
        //渐变涂层
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        gradientLayer.colors = [Constants.ColorPalette.purple.cgColor, Constants.ColorPalette.bluple.cgColor, Constants.ColorPalette.blue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.6)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.4)
        gradientLayer.mask = outCircleLayer
        layer.addSublayer(gradientLayer)
        
        
    }
    
    func speedAnimation() -> Void {
        //NSLog("执行速度动画")
        let speed = speedValue
        
        let endFromValue = outCircleLayer.strokeEnd
        let endTolValue = speed / 30
        
        let eAnimation = CABasicAnimation(keyPath: "strokeEnd")
        eAnimation.beginTime = CACurrentMediaTime()
        eAnimation.fromValue = endFromValue
        eAnimation.toValue = endTolValue
        
 
        outCircleLayer.add(eAnimation, forKey: "stroke")
        outCircleLayer.strokeEnd = endTolValue
 
    }

}
