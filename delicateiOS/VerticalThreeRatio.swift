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
        drawLine(facePoints![23], to: facePoints![17])
        drawHorizontalLine(facePoints![23])
        drawHorizontalLine(facePoints![41])
        drawHorizontalLine(facePoints![7])
    }
}
