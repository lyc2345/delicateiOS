//
//  Scaleline.swift
//  delicateiOS
//
//  Created by John Wu on 2016/11/2.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

class Scaleline: BasicDrawerView{
    
    override func drawRect(rect: CGRect) {
        let scale = ((facePoints![29].x-facePoints![27].x) + (facePoints![32].x-facePoints![34].x))/2
        drawLine(CGPoint(x: 100,y: facePoints![27].y), to: CGPoint(x: 100+scale,y: facePoints![27].y))
    }
}
