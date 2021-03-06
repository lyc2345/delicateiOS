//
//  BasicDrawer.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/12.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit


class BasicDrawerView: UIView{
    
    let Mytag = 1
    
    override var frame: CGRect{
        didSet{
            
        }
    }
    
    var facePoints: [CGPoint]?{
        didSet{
            print("facePoint count = \(facePoints?.count)")
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tag = Mytag
        //transparent
        backgroundColor = UIColor(white: 0, alpha: 0)
        opaque = false
        tintColor = UIColor.blackColor()
        initGestureRecognizers()
    }
    
    func initGestureRecognizers() {
        let panGR = UIPanGestureRecognizer(target: self, action: "didPan:")
        addGestureRecognizer(panGR)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didPan(panGR: UIPanGestureRecognizer) {
//        self.superview!.bringSubviewToFront(self)
        var translation = panGR.translationInView(self)
        self.center.x += translation.x
        self.center.y += translation.y
        panGR.setTranslation(CGPointZero, inView: self)
    }
    
    func drawLine(point: CGPoint,to: CGPoint){
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextMoveToPoint(context,point.x,point.y)
        CGContextAddLineToPoint(context, to.x,to.y)
        CGContextStrokePath(context)
    }
    
    func drawVerticalLine(point: CGPoint){
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextMoveToPoint(context,point.x,0)
        CGContextAddLineToPoint(context, point.x,self.frame.size.height)
        CGContextStrokePath(context)
    }
    
    func drawHorizontalLine(point: CGPoint){
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextMoveToPoint(context,0,point.y)
        CGContextAddLineToPoint(context, self.frame.size.width,point.y)
        CGContextStrokePath(context)
    }
    
    func drawPoint(point: CGPoint){
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextMoveToPoint(context,point.x,point.y)
        CGContextAddLineToPoint(context, point.x+1,point.y+1)
        CGContextStrokePath(context)
    }
}

