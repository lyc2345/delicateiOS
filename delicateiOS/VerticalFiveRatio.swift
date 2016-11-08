//
//  HorizontalFiveRatio.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/12.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

class VerticalFiveRatio: BasicDrawerView{
    
    var ratios: [CGFloat]? = [CGFloat]()
    var points = [0,27,29,34,32,14]
    
    override func drawRect(rect: CGRect) {
        
        // two eyes average width
        let eyeWidth = ((facePoints![29].x-facePoints![27].x) + (facePoints![32].x-facePoints![34].x))/2
        
        for (index,point) in points.enumerate(){
            drawVerticalLine(facePoints![point])
            if index < 5 {
                let horizontalDistance = facePoints![points[index+1]].x - facePoints![point].x
                let ratio = horizontalDistance/eyeWidth
                let label = UILabel(frame: CGRectMake(facePoints![point].x+(horizontalDistance-10)/2,20,20,20))
                label.font = label.font.fontWithSize(8)
                label.text = NSString(format:"%.1f", ratio) as String
                addSubview(label)
                ratios?.append(ratio)
                print(ratio)
            }
        }
//        drawVerticalLine(facePoints![0])
//        drawVerticalLine(facePoints![27])
//        drawVerticalLine(facePoints![29])
//        drawVerticalLine(facePoints![34])
//        drawVerticalLine(facePoints![32])
//        drawVerticalLine(facePoints![14])
    }
}
