//
//  FaceTracker.m
//  testFaceTrackSwift
//
//  Created by John Wu on 2016/10/3.
//  Copyright © 2016年 John Wu. All rights reserved.
//

#import "FaceTracker.h"

//#include "com/tastenkunst/cpp/brf/nxt/ios/examples/ExamplePointTrackingIOS.hpp"
//#include "com/tastenkunst/cpp/brf/nxt/ios/examples/ExampleFaceDetectionIOS.hpp"
#include "com/tastenkunst/cpp/brf/nxt/ios/examples/ExampleFaceTrackingIOS.hpp"
//#include "com/tastenkunst/cpp/brf/nxt/ios/examples/ExampleFaceSubstitutionIOS.hpp"
//#include "com/tastenkunst/cpp/brf/nxt/ios/examples/ExampleCandideTrackingIOS.hpp"

#include "com/tastenkunst/cpp/brf/nxt/utils/StringUtils.hpp"



@implementation FaceTracker

int _cameraWidth  = 480;
int _cameraHeight = 640;
//320 497
ExampleFaceTrackingIOS _example(_cameraWidth, _cameraHeight);
const std::function< void() > brf::BRFManager::READY = []{ _example.onReadyBRF(); };
double DrawingUtils::CANVAS_WIDTH = (double)_cameraWidth;
double DrawingUtils::CANVAS_HEIGHT = (double)_cameraHeight;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _example.init();
    }
    return self;
}

- (void)update:(uint8_t*) mutablePointer{
    _example.update(mutablePointer);
}

- (NSMutableArray *)updateGUI:(CGContextRef) context{
    std::vector< std::shared_ptr<brf::Point> > allPoints = _example.updateGUI(context);
    NSMutableArray *myArray = [NSMutableArray array];
    if (allPoints.size() >= 68){
        for(int i = 0;i<68;i++){
            CGPoint point = CGPointMake(allPoints[i]->x*320/480, allPoints[i]->y*497/640);
            NSValue *aa = [NSValue valueWithCGPoint:point];
            [myArray addObject:aa];
        }
    }
    return myArray;
}

@end


