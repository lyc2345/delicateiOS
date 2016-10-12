//
//  HorizontalFiveRatio.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/12.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

class HorizontalFiveRatio: BasicDrawerView{
    
    override func drawRect(rect: CGRect) {
        drawVerticalLine(facePoints![0])
        drawVerticalLine(facePoints![27])
        drawVerticalLine(facePoints![29])
        drawVerticalLine(facePoints![34])
        drawVerticalLine(facePoints![32])
        drawVerticalLine(facePoints![14])
    }
}
