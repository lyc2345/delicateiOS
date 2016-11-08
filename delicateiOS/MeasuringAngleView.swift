//
//  MeasuringAngleView.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/19.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

class MeasuringAngleView: UIView{
    
    let MyTag = 2
    var bar1: Bar!
    var bar2: Bar!
    var circle: UIView!
    var text: UILabel!
    
    var angle: CGFloat? {
        didSet{
            let dd = Int(angle!)
            text.text = "\(dd)"
        }
    }
    
    override var frame: CGRect{
        didSet{
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI(frame)
    }
    
    func createUI(frame: CGRect){
        setupBar1(frame)
        setupBar2(frame)
        setupCenter()
        tag = MyTag
        backgroundColor = UIColor(white: 0, alpha: 0)
        opaque = false
    }
    
    private func setupCenter(){
        print("measure frame = \(frame)")
        print("measure center = \(center)")
        circle = UIView(frame: CGRectMake(0,0,50,50))
        circle.backgroundColor = UIColor(white: 0, alpha: 0)
//        circle.backgroundColor = UIColor.blackColor()
        circle.layer.cornerRadius = circle.frame.width / 2.0;
        circle.center = self.center
        circle.tag = 3
        self.addSubview(circle)
        text = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        text.textColor = UIColor.whiteColor()
        text.textAlignment = NSTextAlignment.Center
        text.center = self.center
        self.addSubview(text)
    }
    
    private func setupBar1(frame: CGRect){
        bar1 = Bar(frame: CGRect(x: 0, y: 0, width: frame.width/2, height: 20))
        bar1.center = self.center
        bar1.tag = 1
        self.addSubview(bar1)
        bar1.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
    }
    
    private func setupBar2(frame: CGRect){
        bar2 = Bar(frame: CGRect(x: 0, y: 0, width: frame.width/2, height: 20))
        bar2.center = self.center
        bar2.tag = 2
        self.addSubview(bar2)
        bar2.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
    }
    
    func addTouchMovement(gesture: UIPanGestureRecognizer){
        circle?.addGestureRecognizer(gesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
