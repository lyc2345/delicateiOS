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
    
    var detectionImage: DetectionImage?{
        didSet{
            print("point = \(detectionImage?.facePoints)")
            threeView?.facePoints = detectionImage!.facePoints
            fiveView?.facePoints = detectionImage!.facePoints
            phaseView?.facePoints = detectionImage!.facePoints
            mouseNoseView?.facePoints = detectionImage!.facePoints
        }
    }
    
    
    let measure = 1
    let detect = 2
    let line = 3
    
    var faceImages = [UIImage]()
    var drawLines: [UIImageView]? = [UIImageView]()
    var startPoint: CGPoint?
    var endPoint: CGPoint?
    
    var barTailPoint1: CGPoint? = CGPoint(x: 0, y: 200)
    var barTailPoint2: CGPoint? = CGPoint(x: 0, y: 200)
    
    var threeView: HorizontalThreeRatio?
    var fiveView: VerticalFiveRatio?
    var mouseNoseView: MouseNoseRatio?
    var phaseView: FourPhase?
    var measuringAngleView : MeasuringAngleView?
    
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
    
    @IBAction func clean(sender: AnyObject) {
        cleanView(line)
        cleanView(detect)
        cleanView(measure)
    }
    
    @IBAction func openTracker(sender: AnyObject) {
        cleanView(line)
        cleanView(detect)
        cleanView(measure)
        faceTrack = storyboard?.instantiateViewControllerWithIdentifier("camera") as? FaceTrackCamera
        faceTrack?.delegate = self
        presentViewController(faceTrack!, animated: true, completion: nil)
    }
    
    @IBAction func picFilter(sender: AnyObject) {
        guard let _ = mainImageView.image else{
            return
        }
        cleanView(line)
        cleanView(detect)
        cleanView(measure)
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
        cleanView(detect)
        cleanView(line)
        isMeasureShow = true
        measuringAngleView = MeasuringAngleView(frame: CGRectMake(0,0,mainImageView.frame.width,mainImageView.frame.height))
        measuringAngleView?.center = self.mainImageView.center
        let myGesture = UIPanGestureRecognizer(target: self, action: "handleMeasureAngleMove:")
        measuringAngleView!.addTouchMovement(myGesture)
        view.insertSubview(measuringAngleView!, aboveSubview: mainImageView)
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
        threeView = HorizontalThreeRatio()
        fiveView = VerticalFiveRatio()
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
    }
    
    private func changeDrawerView(view: BasicDrawerView?){
        
        guard let _ = mainImageView.image else{
            print("main image view is null")
            return
        }

        guard mainImageView.image!.isKindOfClass(DetectionImage) else{
            return
        }
        cleanView(line)
        cleanView(detect)
        cleanView(measure)
        let scaleView = ScaleView(frame: self.mainImageView.frame)
        scaleView.addDrawerView(view!)
        scaleView.center = self.mainImageView.center
        scaleView.zoomScale = 1
        self.view.insertSubview(scaleView, aboveSubview: self.mainImageView)
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
            guard let _ = mainImageView.image else{
                return
            }
            startPoint = touch.locationInView(self.mainImageView)
            let drawline = UIImageView(frame: self.mainImageView.frame)
            drawline.tag = 3
            drawLines?.append(drawline)
            self.view.addSubview(drawLines![(drawLines?.count)!-1])
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first as? AnyObject {
            if isMeasureShow {
                for subview in self.measuringAngleView!.subviews {
                    if touch.view == subview {
                        let position = touch.locationInView(self.measuringAngleView!)
                        let target = subview.center
                        let angle = atan2(target.y-position.y, target.x-position.x)
                        subview.transform = CGAffineTransformMakeRotation(angle)
                        let v1 = CGVector(dx: barTailPoint1!.x - target.x, dy: barTailPoint1!.y - target.y)
                        let v2 = CGVector(dx: barTailPoint2!.x - target.x, dy: barTailPoint2!.y - target.y)
                        
                        switch subview.tag {
                        case 1:
                            barTailPoint1 = position
                            self.measuringAngleView?.angle = calculateAngleDeg(v2, another: v1)
                            break
                        case 2:
                            barTailPoint2 = position
                            self.measuringAngleView?.angle = calculateAngleDeg(v1, another: v2)
                            break
                        default:
                            break
                        }
                    }
                }
            }else{
                let currentPoint = touch.locationInView(mainImageView)
                if let _ = startPoint{
                    drawLineFrom(startPoint!, toPoint: currentPoint,imageView: drawLines![(drawLines?.count)!-1])
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first as? AnyObject {
            endPoint = touch.locationInView(mainImageView)
        }
        UIGraphicsEndImageContext()
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint,imageView: UIImageView) {
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        imageView.image = nil
        imageView.image?.drawInRect(CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
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
            self.detectionImage = image as? DetectionImage
        }
        cleanView(line)
        cleanView(detect)
        cleanView(measure)
        mainImageView.image = image
    }
}
