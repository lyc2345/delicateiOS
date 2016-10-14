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
    
    var threeView: VerticalThreeRatio?
    var fiveView: HorizontalFiveRatio?
    var mouseNoseView: MouseNoseRatio?
    var phaseView: FourPhase?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func phasebtn(sender: AnyObject) {
        cleanView()
        scrollView.addSubview(phaseView!)
        centerScrollViewContents(phaseView!)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.zoomScale = 1
    }
    
    @IBAction func mousebtn(sender: AnyObject) {
        cleanView()
        scrollView.addSubview(mouseNoseView!)
        centerScrollViewContents(mouseNoseView!)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.zoomScale = 1
    }
    @IBAction func fivebtn(sender: AnyObject) {
        cleanView()
        scrollView.addSubview(fiveView!)
        centerScrollViewContents(fiveView!)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.zoomScale = 1
    }
    
    @IBAction func threebtn(sender: AnyObject) {
        cleanView()
//        scrollView.contentSize = threeView!.frame.size
        scrollView.addSubview(threeView!)
        centerScrollViewContents(threeView!)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.zoomScale = 1
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
        scrollView.backgroundColor = UIColor.clearColor()
//        scrollView.contentSize = CGSize(width: 150, height: 600)
        print("scrollview contentsize = \(scrollView.contentSize)")
        scrollView.delegate = self
        settingScrollView()
    }
    private func settingScrollView(){
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1.3
        scrollView.zoomScale = 1;
        centerScrollViewContents(imageView!)
    }
    
    private func cleanView(){
        for subView in scrollView.subviews{
            if subView.tag == 1 {
                subView.removeFromSuperview()
            }
        }
    }
    
    func centerScrollViewContents(view: UIView) {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = view.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        view.frame = contentsFrame
    }
    
    override func viewWillAppear(animated: Bool) {
        imageView.image = profileImage
        print("main face points = \(facePoints)")
        print("main face points count = \(facePoints?.count)")
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        var mySubView: UIView?
        mySubView = imageView
        for subView in scrollView.subviews{
            if subView.tag == 1 {
                mySubView = subView
            }
        }
        return mySubView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        var mySubView: UIView?
        mySubView = imageView
        for subView in scrollView.subviews{
            if subView.tag == 1 {
                mySubView = subView
            }
        }
        centerScrollViewContents(mySubView!)
    }
}
