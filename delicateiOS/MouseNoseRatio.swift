//
//  MouseNoseRatio.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/14.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

class MouseNoseRatio: BasicDrawerView{
    
    override func drawRect(rect: CGRect) {
        drawLine(facePoints![39], to: facePoints![43])
        drawLine(facePoints![48], to: facePoints![54])
    }
}
