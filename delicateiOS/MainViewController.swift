//
//  MainViewController.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/10.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit


class MainViewController: UIViewController{
    
    
    var profileImage: UIImage?
    var facePoints: [CGPoint]?
    
    var drawingView: DrawingView?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        drawingView = DrawingView(frame: self.view.frame)
        drawingView?.facePoints = facePoints
        self.view.addSubview(drawingView!)
    }
    
    override func viewWillAppear(animated: Bool) {
        imageView.image = profileImage
        print("main face points = \(facePoints)")
        print("main face points count = \(facePoints?.count)")
    }
}
