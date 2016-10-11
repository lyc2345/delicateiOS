//
//  ViewController.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/5.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var profileImage: UIImage?

    
    @IBAction func takePic(sender: AnyObject) {
        let faceCamera = self.storyboard?.instantiateViewControllerWithIdentifier("camera") as! FaceTrackCamera
        showViewController(faceCamera, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

