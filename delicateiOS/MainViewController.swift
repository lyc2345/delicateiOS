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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func fivebtn(sender: AnyObject) {
//        initView()
        scrollView.addSubview(fiveView!)
    }
    
    @IBAction func threebtn(sender: AnyObject) {
//        initView()
        scrollView.addSubview(threeView!)
    }
    
    override func viewDidLoad() {
        threeView = VerticalThreeRatio(frame: self.imageView.frame)
        threeView?.facePoints = facePoints
        fiveView = HorizontalFiveRatio(frame: self.imageView.frame)
        fiveView?.facePoints = facePoints
        scrollView.backgroundColor = UIColor.clearColor()
//        scrollView.contentSize.height = 1000
//        scrollView.contentSize.width = 1000
        scrollView.contentSize = imageView.frame.size
        scrollView.delegate = self
//        scrollView.minimumZoomScale = 0.1
//        scrollView.maximumZoomScale = 4.0
//        scrollView.zoomScale = 1.0
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale;
        
        centerScrollViewContents()
        
//        self.view.addSubview(threeView!)
//        self.view.addSubview(fiveView!)
        
//        drawingView?.snp_makeConstraints(closure: { (make) in
//            make.top.equalTo(self.imageView.snp_top)
//            make.left.equalTo(self.imageView.snp_left)
//        })
    }
    
    private func initView(){
        for subView in self.view.subviews{
            if subView.tag == 1 {
                subView.removeFromSuperview()
            }
        }
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = threeView!.frame
        
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
        
        threeView!.frame = contentsFrame
    }
    
    override func viewWillAppear(animated: Bool) {
        imageView.image = profileImage
        print("main face points = \(facePoints)")
        print("main face points count = \(facePoints?.count)")
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return threeView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView!) {
        centerScrollViewContents()
    }
}
