//
//  Renderer.swift
//  delicateiOS
//
//  Created by John Wu on 2016/11/7.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

protocol Renderer {
    func moveTo(point: CGPoint)
    func lineTo(point: CGPoint)
}

extension CGContext: Renderer{
    func moveTo(point: CGPoint) {
        CGContextSetLineWidth(self, 2.0)
        CGContextSetStrokeColorWithColor(self, UIColor.redColor().CGColor)
        CGContextMoveToPoint(self,point.x,point.y)
        CGContextStrokePath(self)
    }
    
    func lineTo(point: CGPoint) {
        CGContextSetLineWidth(self, 2.0)
        CGContextSetStrokeColorWithColor(self, UIColor.redColor().CGColor)
        CGContextAddLineToPoint(self,point.x,point.y)
        CGContextStrokePath(self)
    }
}