//
//  DrawingView.swift
//  testFaceTrackSwift
//
//  Created by John Wu on 2016/10/4.
//  Copyright © 2016年 John Wu. All rights reserved.
//

class DrawingView: UIView {
    
    
    var facePoints: [CGPoint]?{
        didSet{
            print("facePoint count = \(facePoints?.count)")
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0)
        opaque = false
        tintColor = UIColor.blackColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        var i = 0;
        let l = facePoints?.count;
        print("l = \(l)")
        while i<l {
            if let point = facePoints?[i] {
                CGContextMoveToPoint(context,point.x,point.y)
                CGContextAddLineToPoint(context, point.x+1,point.y+1)
                CGContextStrokePath(context)
            }
            i++
        }
//        if minY != nil {
//            CGContextMoveToPoint(context, 0,200)
//            CGContextAddLineToPoint(context, 200,200)
//            CGContextStrokePath(context)
//        }
    }
}