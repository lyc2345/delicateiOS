//
//  MainViewController.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/10.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit
import GPUImage


class MainViewController: UIViewController,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MyImageViewDelegate,FaceTrackDelegate{
    
    var profileImage: UIImage?
    var detectionImage: DetectionImage?{
        didSet{
            print("point = \(detectionImage?.facePoints)")
            threeView?.facePoints = detectionImage!.facePoints
            fiveView?.facePoints = detectionImage!.facePoints
            phaseView?.facePoints = detectionImage!.facePoints
            mouseNoseView?.facePoints = detectionImage!.facePoints
        }
    }
    
    var faceImages = [UIImage]()
    var drawLines: [UIImageView]? = [UIImageView]()
    var startPoint: CGPoint?
    var endPoint: CGPoint?
    
    var barPoint1: CGPoint?
    var barPoint2: CGPoint?
    
    var threeView: VerticalThreeRatio?
    var fiveView: HorizontalFiveRatio?
    var mouseNoseView: MouseNoseRatio?
    var phaseView: FourPhase?
    var measuringAngleView : MeasuringAngleView?
    var scaleView : ScaleView?
    
    var imagePicker: UIImagePickerController!
    var faceTrack: FaceTrackCamera?
    var isMeasureShow: Bool = false
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var faceView1: MyImageView!
    @IBOutlet weak var faceView2: MyImageView!
    @IBOutlet weak var faceView3: MyImageView!
    @IBOutlet weak var faceView4: MyImageView!
    @IBOutlet weak var faceView5: MyImageView!
    @IBOutlet weak var faceView6: MyImageView!
    @IBOutlet weak var faceView7: MyImageView!
    
    @IBAction func openTracker(sender: AnyObject) {
        faceTrack = storyboard?.instantiateViewControllerWithIdentifier("camera") as? FaceTrackCamera
        faceTrack?.delegate = self
        presentViewController(faceTrack!, animated: true, completion: nil)
    }
    
    @IBAction func picFilter(sender: AnyObject) {
        guard let _ = mainImageView.image else{
            return
        }
        let filter = GPUImageSketchFilter()
        filter.edgeStrength = 1.3
        let image = filter.imageByFilteringImage(mainImageView.image!)
        mainImageView.image = image
    }
    
    @IBAction func openCamera(sender: AnyObject) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func measurebtn(sender: AnyObject) {
        guard let _ = mainImageView.image else{
            return
        }
        cleanView(2)
        isMeasureShow = true
        measuringAngleView = MeasuringAngleView(frame: CGRectMake(0,0,mainImageView.frame.width,mainImageView.frame.height))
        measuringAngleView?.center = self.mainImageView.center
        let myGesture = UIPanGestureRecognizer(target: self, action: "handleMeasureAngleMove:")
        measuringAngleView!.addTouchMovement(myGesture)
        
//        view.addSubview(measuringAngleView!)
        view.insertSubview(measuringAngleView!, aboveSubview: mainImageView)
//        self.view.bringSubviewToFront(btnThree)
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
        threeView = VerticalThreeRatio()
        fiveView = HorizontalFiveRatio()
        mouseNoseView = MouseNoseRatio()
        phaseView = FourPhase()

        faceView1.delegate = self
        faceView2.delegate = self
        faceView3.delegate = self
        faceView4.delegate = self
        faceView5.delegate = self
        faceView6.delegate = self
        faceView7.delegate = self
        
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        barPoint1 = CGPoint(x: 0, y: 200)
        barPoint2 = CGPoint(x: 0, y: 200)
    }
    
    private func changeDrawerView(view: BasicDrawerView?){
        
        guard let _ = mainImageView.image else{
            print("main image view is null")
            return
        }

        guard mainImageView.image!.isKindOfClass(DetectionImage) else{
            return
        }
        
        cleanView(1)
        cleanView(2)
        scaleView = ScaleView(frame: self.mainImageView.frame)
        scaleView?.addDrawerView(view!)
        scaleView?.center = self.mainImageView.center
        scaleView?.zoomScale = 1
        self.view.insertSubview(scaleView!, aboveSubview: self.mainImageView)
    }
    
    private func cleanView(tag:Int?){
        isMeasureShow = false
        for subView in view.subviews{
            if subView.tag == tag {
                subView.removeFromSuperview()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        mainImageView.image = faceImages.last
    }
    
    override func viewDidAppear(animated: Bool) {
        threeView?.frame = self.mainImageView.frame
        fiveView?.frame = self.mainImageView.frame
        mouseNoseView?.frame = self.mainImageView.frame
        phaseView?.frame = self.mainImageView.frame
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first as? AnyObject {
            startPoint = touch.locationInView(self.view)
            drawLines?.append(UIImageView(frame: self.view.frame))
            self.view.addSubview(drawLines![(drawLines?.count)!-1])
            print("began = \(startPoint)")
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first as? AnyObject {
            if isMeasureShow {
                for subview in self.measuringAngleView!.subviews {
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
            }else{
                let currentPoint = touch.locationInView(view)
                drawLineFrom(startPoint!, toPoint: currentPoint,imageView: drawLines![(drawLines?.count)!-1])
                print("moved = \(currentPoint)")
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first as? AnyObject {
            endPoint = touch.locationInView(view)
            print("end = \(endPoint)")
        }
        UIGraphicsEndImageContext()
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint,imageView: UIImageView) {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        imageView.image = nil
        imageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        CGContextStrokePath(context)
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.alpha = 1
        UIGraphicsEndImageContext()
        
    }

    
    func handleMeasureAngleMove(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            self.measuringAngleView!.center = CGPoint(x:self.measuringAngleView!.center.x + translation.x,
                                  y:self.measuringAngleView!.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        faceImages.append(image!)
        refreshSubImages()
    }
    
    func takeFaceTrackPicFinish(detectionImage: DetectionImage) {
        faceTrack?.dismissViewControllerAnimated(true, completion: nil)
        self.detectionImage = detectionImage
        faceImages.append(detectionImage)
        refreshSubImages()
    }
    
    func refreshSubImages(){
        switch faceImages.count {
        case 1:
            faceView1.image = faceImages[0]
            break
        case 2:
            faceView2.image = faceImages[1]
            break
        case 3:
            faceView3.image = faceImages[2]
            break
        case 4:
            faceView4.image = faceImages[3]
            break
        case 5:
            faceView5.image = faceImages[4]
            break
        case 6:
            faceView6.image = faceImages[5]
            break
        case 7:
            faceView7.image = faceImages[6]
            break
        default:
            break
        }
    }
    
    func showingBy(image: UIImage) {
        if(image.isKindOfClass(DetectionImage)){
            print("it is detection")
            self.detectionImage = image as? DetectionImage
        }
        cleanView(1)
        cleanView(2)
        mainImageView.image = image
    }
    

}
