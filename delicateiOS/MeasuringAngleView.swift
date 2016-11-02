//
//  MeasuringAngleView.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/19.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

enum BarTag :Int{
    case first = 1
    case second = 2
    case circle = 3
}

class MeasuringAngleView: UIView{
    
    var bar1: Bar!
    var bar2: Bar!
    var circle: UIView!
    var text: UILabel!
    
    var angle: CGFloat? {
        didSet{
            let dd = Int(angle!)
            text.text = "\(dd)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tag = 2
        circle = UIView(frame: CGRectMake(0,0,50,50))
        circle.backgroundColor = UIColor.blackColor()
        circle.layer.cornerRadius = circle.frame.width / 2.0;
        circle.center = self.center
        circle.tag = BarTag.circle.rawValue
        self.addSubview(circle)
        text = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        text.textColor = UIColor.whiteColor()
        text.textAlignment = NSTextAlignment.Center
        text.center = self.center
        self.addSubview(text)
        
        
        bar2 = Bar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        bar2.center = self.center
        bar2.tag = BarTag.second.rawValue
        self.addSubview(bar2)
        bar2.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        
        bar1 = Bar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        bar1.center = self.center
        bar1.tag = BarTag.first.rawValue
        bar1.line?.backgroundColor = UIColor.whiteColor()
        self.addSubview(bar1)
        bar1.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        backgroundColor = UIColor(white: 0, alpha: 0)
        opaque = false
        
        
        
    }
    
    func addTouchMovement(gesture: UIPanGestureRecognizer){
        circle?.addGestureRecognizer(gesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
