//
//  Bar.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/19.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

class Bar: UIView{
    
    var line: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        line = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 2))
        line!.backgroundColor = UIColor.greenColor()
        line?.center = self.center
        self.addSubview(line!)
        backgroundColor = UIColor(white: 0, alpha: 0)
//        backgroundColor = UIColor.redColor()
        opaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
