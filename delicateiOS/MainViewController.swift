//
//  MainViewController.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/10.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit


class MainViewController: UIViewController,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MyImageViewDelegate,FaceTrackDelegate{
    
    let defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    
    var profileImage: UIImage?
    var detectionImage: DetectionImage?{
        didSet{
            print("point = \(detectionImage?.facePoints)")
            threeView?.facePoints = detectionImage!.facePoints
            fiveView?.facePoints = detectionImage!.facePoints
            phaseView?.facePoints = detectionImage!.facePoints
            mouseNoseView?.facePoints = detectionImage!.facePoints
            faceImages.append(detectionImage!)
            photoCount++
            photoClick = photoCount
        }
    }
    
    var faceImages = [UIImage]()
    
    var facePoints: [CGPoint]?
    var barPoint1: CGPoint?
    var barPoint2: CGPoint?
    
    var threeView: VerticalThreeRatio?
    var fiveView: HorizontalFiveRatio?
    var mouseNoseView: MouseNoseRatio?
    var phaseView: FourPhase?
    var measuringAngleView : MeasuringAngleView?
    var scrollView: ScaleView?
    
    var photoClick = 0
    var photoCount = 0
    
    var imagePicker: UIImagePickerController!
    var faceTrack: FaceTrackCamera?
    
    @IBOutlet weak var imageView: UIImageView!
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
    
    @IBAction func openCamera(sender: AnyObject) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
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
        threeView = VerticalThreeRatio(frame: adaptFrame(self.imageView.frame))
        fiveView = HorizontalFiveRatio(frame: adaptFrame(self.imageView.frame))
        phaseView = FourPhase(frame: adaptFrame(self.imageView.frame))
        mouseNoseView = MouseNoseRatio(frame: adaptFrame(self.imageView.frame))
        measuringAngleView = MeasuringAngleView(frame: CGRectMake(0, 0, 400, 400))
        measuringAngleView?.center = self.view.center

        let myGesture = UIPanGestureRecognizer(target: self, action: "handleMovement:")
        faceView1.delegate = self
        faceView2.delegate = self
        faceView3.delegate = self
        faceView4.delegate = self
        faceView5.delegate = self
        faceView6.delegate = self
        faceView7.delegate = self

        measuringAngleView!.addTouchMovement(myGesture)
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        barPoint1 = CGPoint(x: 0, y: 200)
        barPoint2 = CGPoint(x: 0, y: 200)
    }
    
    private func changeDrawerView(view: BasicDrawerView?){
        cleanView()
        scrollView = ScaleView(frame: self.imageView.frame)
        scrollView?.center = self.imageView.center
        scrollView?.addDrawerView(view!)
        self.view.addSubview(scrollView!)
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
        imageView.image = faceImages.last
        switch photoCount {
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
//        print("main face points = \(facePoints)")
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        faceImages.insert(image!, atIndex: photoCount++)
        faceImages.append(image!)
        
        switch photoCount {
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
        photoCount++
        photoClick = photoCount
    }
    
    func showingBy(image: UIImage) {
        if(image.isKindOfClass(DetectionImage)){
            print("it is detection")
            let detecImage = image as? DetectionImage
            threeView?.facePoints = detecImage!.facePoints
            fiveView?.facePoints = detecImage!.facePoints
            phaseView?.facePoints = detecImage!.facePoints
            mouseNoseView?.facePoints = detecImage!.facePoints
        }
        imageView.image = image
    }
    
    func takePicOver(detectionImage: DetectionImage) {
        faceTrack?.dismissViewControllerAnimated(true, completion: nil)
        self.detectionImage = detectionImage
        
    }
}

extension UIViewController{
    func adaptFrame(frame: CGRect) -> CGRect{
        let useBounds = UIScreen.mainScreen().bounds
        let defaultFrame = CGRect(x: 0, y: 0, width: 320, height: 568)
        let frameRatioWidth = useBounds.width/defaultFrame.width
        let frameRatioHeight = useBounds.height/defaultFrame.height
        return CGRect(x: 0, y: 0, width: frame.width*frameRatioWidth, height: frame.height*frameRatioHeight)
    }
}
