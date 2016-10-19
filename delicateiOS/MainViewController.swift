//
//  MainViewController.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/10.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit


class MainViewController: UIViewController,UIScrollViewDelegate{
    
    let defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    
    var profileImage: UIImage?
    var facePoints: [CGPoint]?
    var barPoint1: CGPoint?
    var barPoint2: CGPoint?
    
    var threeView: VerticalThreeRatio?
    var fiveView: HorizontalFiveRatio?
    var mouseNoseView: MouseNoseRatio?
    var phaseView: FourPhase?
    var measuringAngleView : MeasuringAngleView?
    var scrollView: ScaleView?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func measurebtn(sender: AnyObject) {
        cleanView()
        view.addSubview(measuringAngleView!)
    }
    
    @IBAction func phasebtn(sender: AnyObject) {
        changeDrawerView(phaseView)
    }
    
    @IBAction func mousebtn(sender: AnyObject) {
        changeDrawerView(mouseNoseView)
    }
    
    @IBAction func fivebtn(sender: AnyObject) {
        changeDrawerView(fiveView)
    }
    
    @IBAction func threebtn(sender: AnyObject) {
        changeDrawerView(threeView)
    }
    
    override func viewDidLoad() {
        threeView = VerticalThreeRatio(frame: self.imageView.frame)
        threeView?.facePoints = facePoints
        fiveView = HorizontalFiveRatio(frame: self.imageView.frame)
        fiveView?.facePoints = facePoints
        phaseView = FourPhase(frame: self.imageView.frame)
        phaseView?.facePoints = facePoints
        mouseNoseView = MouseNoseRatio(frame: self.imageView.frame)
        mouseNoseView?.facePoints = facePoints
        measuringAngleView = MeasuringAngleView(frame: CGRectMake(0, 0, 400, 400))
        measuringAngleView?.center = self.view.center

        let myGesture = UIPanGestureRecognizer(target: self, action: "handleMovement:")
        measuringAngleView!.addTouchMovement(myGesture)
        barPoint1 = CGPoint(x: 0, y: 200)
        barPoint2 = CGPoint(x: 0, y: 200)
    }
    
    private func changeDrawerView(view: BasicDrawerView?){
        cleanView()
        scrollView = ScaleView(frame: self.imageView.frame)
        scrollView?.addDrawerView(view!)
        self.view.addSubview(scrollView!)
        scrollView?.center = self.imageView.center
        scrollView!.zoomScale = 1
    }

    
    private func cleanView(){
        for subView in view.subviews{
            if subView.tag == 2 {
                subView.removeFromSuperview()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        imageView.image = profileImage
        print("main face points = \(facePoints)")
        print("main face points count = \(facePoints?.count)")
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //        let touch = touches.anyObject() as UITouch
        var count = 0
        var ccount = 0
        for touch:AnyObject in touches {
            print("around count = \(ccount++)")
            for subview in self.measuringAngleView!.subviews {
                print("\(count++)")
                if touch.view == subview {
                    print("move")
                    var deg: CGFloat?
                    var betweenAngle: CGFloat?
                    let position = touch.locationInView(self.measuringAngleView!)
                    let target = subview.center
                    let angle = atan2(target.y-position.y, target.x-position.x)
                    subview.transform = CGAffineTransformMakeRotation(angle)
                    let v1 = CGVector(dx: barPoint1!.x - target.x, dy: barPoint1!.y - target.y)
                    let v2 = CGVector(dx: barPoint2!.x - target.x, dy: barPoint2!.y - target.y)
                    
                    switch subview.tag {
                    case 1:
                        betweenAngle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
                        barPoint1 = position
                        deg = betweenAngle! * CGFloat(180.0 / M_PI)
                        if deg < 0 { deg! += 360.0 }
                        if deg >= 180 { deg! = abs(deg!-360) }
                        self.measuringAngleView?.angle = deg
                        break
                    case 2:
                        betweenAngle = atan2(v1.dy, v1.dx) - atan2(v2.dy, v2.dx)
                        barPoint2 = position
                        deg = betweenAngle! * CGFloat(180.0 / M_PI)
                        if deg < 0 { deg! += 360.0 }
                        if deg >= 180 { deg! = abs(deg!-360) }
                        self.measuringAngleView?.angle = deg
                        break
                    default:
                     
                        break
                    }
                }
            }
        }
    }
    
    func handleMovement(recognizer:UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            self.measuringAngleView!.center = CGPoint(x:self.measuringAngleView!.center.x + translation.x,
                                  y:self.measuringAngleView!.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }

}
