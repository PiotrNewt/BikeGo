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
    let pointerLayer = CAShapeLayer()  //进度曲线 -> 指针
    
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
        outCircleLayer.lineWidth = 4.0
        outCircleLayer.fillColor = UIColor.clear.cgColor
        outCircleLayer.strokeColor = UIColor.black.cgColor
        
        //内圆
        interCircleLayer.position = CGPoint.zero
        interCircleLayer.lineWidth = 4.0
        interCircleLayer.fillColor = UIColor.clear.cgColor
        interCircleLayer.strokeColor = UIColor.black.cgColor
        
        let outRadius = CGFloat(self.bounds.height / 2) - outCircleLayer.lineWidth //半径
        let interRadius = CGFloat(self.bounds.height / 4) - interCircleLayer.lineWidth
        let wStartAngle = CGFloat(Double.pi / 2) //开始角度
        let WEndAngle = CGFloat(5 * Double.pi / 2) //结束角度
        let width = self.bounds.width
        let height = self.bounds.height
        let modelCenter = CGPoint(x: width / 2, y: height / 2)  //圆心
        
        let outCircle = UIBezierPath(arcCenter: modelCenter, radius: outRadius, startAngle: wStartAngle, endAngle: WEndAngle, clockwise: true)
        let interCircle = UIBezierPath(arcCenter: modelCenter, radius: interRadius, startAngle: wStartAngle, endAngle: WEndAngle, clockwise: true)
        
        outCircleLayer.path = outCircle.cgPath
        interCircleLayer.path = interCircle.cgPath
        
        self.layer.addSublayer(outCircleLayer)
        self.layer.addSublayer(interCircleLayer)
        
        //指针
        pointerLayer.position = CGPoint.zero
        pointerLayer.lineWidth = outRadius - interRadius
        pointerLayer.fillColor = UIColor.clear.cgColor
        pointerLayer.strokeColor = UIColor.red.cgColor
        pointerLayer.strokeStart = 0
        pointerLayer.strokeEnd = 0.005
        
        let pointerRadius = CGFloat(3 * self.bounds.height / 8) - 10
        let pointerStartAngle = CGFloat(3 * Double.pi / 4) 
        let pointerEndAngle = CGFloat(Double.pi / 4)
        
        let pointer = UIBezierPath(arcCenter: modelCenter, radius: pointerRadius, startAngle: pointerStartAngle, endAngle: pointerEndAngle, clockwise: true)
        
        pointerLayer.path = pointer.cgPath
        self.layer.addSublayer(pointerLayer)
        
        
        //刻度
        let perAngle = CGFloat(3 * Double.pi / 100)
        
        for i in 0...50 {
            let perLayer = CAShapeLayer() //刻度
            let startAngle = CGFloat(3 * Double.pi / 4) + perAngle * CGFloat(i)
            let endAngle = startAngle + perAngle / 5
            
            if i % 5 == 0 {
                perLayer.strokeColor = UIColor.black.cgColor
                perLayer.lineWidth = 10
                //刻度值
                let textPoint = calculateTextPositonWithArcCenter(center: modelCenter, angle: startAngle, radius: outRadius - 30)
                let textLabel = UILabel(frame:CGRect(x: textPoint.x - 10, y: textPoint.y - 5, width: 30, height: 15))
                textLabel.text = String(i)
                textLabel.font = UIFont(name: "Bobz Type", size: 10)
                self.addSubview(textLabel)
                
            } else {
                perLayer.strokeColor = UIColor.gray.cgColor
                perLayer.lineWidth = 5
            }
            
            let tickCircle = UIBezierPath(arcCenter: modelCenter, radius: outRadius - perLayer.lineWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            perLayer.path = tickCircle.cgPath
            self.layer.addSublayer(perLayer)
            
        }
        
    }
    
    func calculateTextPositonWithArcCenter(center: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
        let x = radius * CGFloat(cosf(Float(-angle)))
        let y = radius * CGFloat(sinf(Float(-angle)))
        
        return CGPoint(x: center.x + x, y: center.y - y)
    }
    
    func speedAnimation() -> Void {
        NSLog("执行速度动画")
        let speed = speedValue
        
        let startFromValue = pointerLayer.strokeStart
        let startToValue = speed / 50
        let endFromValue = pointerLayer.strokeEnd
        let endTolValue = startToValue + 0.005
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.beginTime = CACurrentMediaTime()
        
        let sAnimation = CABasicAnimation(keyPath: "strokeEnd")
        sAnimation.fromValue = startFromValue
        sAnimation.toValue = startToValue
        
        let eAnimation = CABasicAnimation(keyPath: "strokeEnd")
        eAnimation.fromValue = endFromValue
        eAnimation.toValue = endTolValue
        
        groupAnimation.animations = [sAnimation, eAnimation]
 
        pointerLayer.add(groupAnimation, forKey: "stroke")
        pointerLayer.strokeStart = startToValue
        pointerLayer.strokeEnd = endTolValue
 
    }

}
