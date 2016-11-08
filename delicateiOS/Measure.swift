//
//  Measure.swift
//  delicateiOS
//
//  Created by John Wu on 2016/11/7.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import Foundation

protocol Measure {
    func calculateAngleDeg(base: CGVector,another: CGVector) -> CGFloat
}

extension UIViewController: Measure{
    func calculateAngleDeg(base: CGVector, another: CGVector) -> CGFloat{
        let angle = atan2(base.dy, base.dx) - atan2(another.dy, another.dx)
        var deg = angle * CGFloat(180.0 / M_PI)
        if deg < 0 { deg += 360.0 }
        if deg >= 180 { deg = abs(deg - 360) }
        return deg
    }
}
