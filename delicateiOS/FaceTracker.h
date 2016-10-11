//
//  FaceTracker.h
//  testFaceTrackSwift
//
//  Created by John Wu on 2016/10/3.
//  Copyright © 2016年 John Wu. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureOutput.h>
#import <CoreVideo/CVPixelBuffer.h>


@interface FaceTracker : NSObject
- (void)update:(uint8_t*) mutablePointer;
- (CGPoint *)updateGUI:(CGContextRef) context;
@end
