//
//  VerticalThreeRatio.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/12.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

class VerticalThreeRatio: BasicDrawerView{
    
    override func drawRect(rect: CGRect) {
        let distance = facePoints![41].y - facePoints![23].y
        let topLine = CGPoint(x: 0, y: facePoints![23].y - distance)
        let bottomLine = CGPoint(x: 0, y: facePoints![41].y + distance)
        
        drawHorizontalLine(topLine)
        drawHorizontalLine(facePoints![23])
        drawHorizontalLine(facePoints![41])
        drawHorizontalLine(bottomLine)
        
//        drawHorizontalLine(facePoints![68]) //the top point
//        drawHorizontalLine(facePoints![23])
//        drawHorizontalLine(facePoints![41])
//        drawHorizontalLine(facePoints![7])
    }
}
