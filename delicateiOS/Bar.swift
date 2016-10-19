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
        line = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 2))
        line!.backgroundColor = UIColor.whiteColor()
        line?.center = self.center
        self.addSubview(line!)
        backgroundColor = UIColor(white: 0, alpha: 0)
        opaque = false
//                backgroundColor = UIColor.blackColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
