//
//  FaceTrackCamera.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/5.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit
import AVFoundation
import CoreVideo
import RxSwift
import SnapKit

class FaceTrackCamera:UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate{
    
    @IBOutlet weak var captureImage: UIImageView!
    @IBOutlet weak var imagePreview: UIView!
    
    var floatMiny:CGFloat?
    var facePoints: [CGPoint]?
    
    @IBAction func takeShot(sender: AnyObject) {
        
        //Create the UIImage
        UIGraphicsBeginImageContext(imagePreview.frame.size)
        imagePreview.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
            
        //Save it to the camera roll
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        session?.stopRunning()
        let mainController = self.storyboard?.instantiateViewControllerWithIdentifier("main") as! MainViewController
        mainController.profileImage = image
        mainController.facePoints = facePoints
        showViewController(mainController, sender: nil)
        print("the floatMinY complete = \(floatMiny)")
        
    }

    
    let _cameraWidth = 480
    let _cameraHeight = 640
    let defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    
    var session: AVCaptureSession?
    var videoQueue: dispatch_queue_t?
    var faceTrack: FaceTracker?
    
    let defaultAVCaptureVideoOrientation = AVCaptureVideoOrientation.Portrait 	//portrait/landscape
    let _mirrored = true;
    var _useFrontCam = true;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        initializeCamera()
        faceTrack = FaceTracker()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        autoreleasepool {
            // Get a CMSampleBuffer's Core Video image buffer for the media data
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            
            // Lock the base address of the pixel buffer
            CVPixelBufferLockBaseAddress(imageBuffer!, 0);
            
            // Get the pixel buffer width and height
            let width = CVPixelBufferGetWidth(imageBuffer!);
            let height = CVPixelBufferGetHeight(imageBuffer!);
            
            if(width != _cameraWidth || height != _cameraHeight) {
                
                connection.videoOrientation = defaultAVCaptureVideoOrientation
                connection.videoMirrored = _mirrored
                
                //We unlock the  image buffer
                CVPixelBufferUnlockBaseAddress(imageBuffer!, 0);
                
            } else {
                
                // Get the number of bytes per row for the pixel buffer
                
                let baseAddress = UnsafeMutablePointer<UInt8>(CVPixelBufferGetBaseAddress(imageBuffer!))
                
                // Create a device-dependent RGB color space
                let colorSpace = CGColorSpaceCreateDeviceRGB();
                
                // Create a bitmap graphics context with the sample buffer data
                let context: CGContextRef = CGBitmapContextCreate(
                    baseAddress, width, height, 8, CVPixelBufferGetBytesPerRow(imageBuffer!),
                    colorSpace, CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.NoneSkipFirst.rawValue)!
                
                faceTrack!.update(baseAddress);
                
//                let pointsMemory = UnsafeMutablePointer.alloc(68)
                if let points = faceTrack?.updateGUI(context){
                    if points.count >= 69{
                        var i = 0;
                        var pointsA: [CGPoint]?
                        pointsA = [CGPoint]()
                        while(i<69){
                            let point = points.objectAtIndex(i).CGPointValue()
                            pointsA?.append(point)
                            i++
                        }
                        facePoints = pointsA
                    }
                }
                
                // Create a Quartz image from the pixel data in the bitmap graphics context
                let quartzImage: CGImageRef = CGBitmapContextCreateImage(context)!
                // Unlock the pixel buffer
                CVPixelBufferUnlockBaseAddress(imageBuffer!, 0);
                
                // Create an image object from the Quartz image
                let image = UIImage.init(CGImage: quartzImage)
                
                captureImage.hidden = false;
                dispatch_sync(dispatch_get_main_queue()) {
                    self.captureImage.image = image;
//                    self.drawView!.minY = floatMiny
                }
            }
        }
    }
    
    func initializeCamera(){
        session = AVCaptureSession()
        session?.sessionPreset = defaultAVCaptureSessionPreset
        
        let captureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
        captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        //AVLayerVideoGravityResizeAspectFill
        
        captureVideoPreviewLayer.frame = self.imagePreview.bounds;
        print("captureVideoPreviewLayer frame = \(captureVideoPreviewLayer.frame)")
        imagePreview.layer.addSublayer(captureVideoPreviewLayer)
        imagePreview.addSubview(self.captureImage)
        
        let view = imagePreview
        let viewLayer = view.layer
        viewLayer.masksToBounds = true
        
        let bounds = view.bounds
        captureVideoPreviewLayer.frame = bounds
        
        let devices = AVCaptureDevice.devices()
        var frontCamera: AVCaptureDevice?
        var backCamera: AVCaptureDevice?
        
        for device in devices {
            
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if (device.position == AVCaptureDevicePosition.Back) {
                    print("Device position : back");
                    backCamera = device as? AVCaptureDevice
                }
                else {
                    print("Device position : front");
                    frontCamera = device as? AVCaptureDevice
                }
            }
        }
        
        if (!_useFrontCam) {
            do{
                let input = try AVCaptureDeviceInput(device: backCamera)
                session?.addInput(input)
            }catch{
                print("ERROR: trying to open camera: \(error)");
            }
        }
        
        if (_useFrontCam) {
            do{
                let input = try AVCaptureDeviceInput(device: frontCamera)
                session?.addInput(input)
            }catch{
                print("ERROR: trying to open camera: \(error)");
            }
        }
        
        // Create a VideoDataOutput and add it to the session
        let videoOutput = AVCaptureVideoDataOutput()
        
        
        let rgbOutputSettings = NSDictionary(object: Int(kCVPixelFormatType_32BGRA), forKey: kCVPixelBufferPixelFormatTypeKey as String) as [NSObject : AnyObject]
        videoOutput.videoSettings = rgbOutputSettings
        videoOutput.alwaysDiscardsLateVideoFrames = true
        // discard if the data output queue is blocked (as we process the still image)
        
        // Configure your output.
        videoQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        //dispatch_release(videoQueue);
        
        session?.addOutput(videoOutput)
        
        // Start the session running to start the flow of data
        session?.startRunning()
    }
}
