//
//  Floss.swift
//  delicateiOS
//
//  Created by John Wu on 2016/11/7.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

protocol Floss {
    func moveTo(point: CGPoint)
    func lineTo(point: CGPoint)
}

extension UIImageView: Floss{
    func moveTo(point: CGPoint) {
        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()
        print("move context = \(self)")
        context?.moveTo(point)
    }
    
    func lineTo(point: CGPoint) {
//        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()
        self.image = nil
        self.image?.drawInRect(CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        context?.lineTo(point)
        print("lineTo context = \(self)")
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        self.alpha = 1
        UIGraphicsEndImageContext()
    }
}