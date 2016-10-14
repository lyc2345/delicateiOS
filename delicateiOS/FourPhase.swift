//
//  FourPhase.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/14.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

class FourPhase: BasicDrawerView{
    
    override func drawRect(rect: CGRect) {
        drawVerticalLine(facePoints![67])
        drawHorizontalLine(facePoints![67])
    }
}
