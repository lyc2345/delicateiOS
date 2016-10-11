#ifndef __brf__ios__ExampleFaceTrackingIOS__
#define __brf__ios__ExampleFaceTrackingIOS__

#include <cstdlib>
#include <cstdint>
#include <string>
#include <vector>

#include "com/tastenkunst/cpp/brf/nxt/BRFMode.hpp"
#include "com/tastenkunst/cpp/brf/nxt/BRFState.hpp"

#include "com/tastenkunst/cpp/brf/nxt/geom/Rectangle.hpp"

#include "com/tastenkunst/cpp/brf/nxt/ios/utils/DrawingUtils.hpp"

#include "ExampleBase.hpp"

class ExampleFaceTrackingIOS : public ExampleBase {

	public: brf::Rectangle _faceDetectionROI;
	
	public: ExampleFaceTrackingIOS(int width, int height) :
			ExampleBase(width, height, true),
			_faceDetectionROI() {
	}
	
	public: ~ExampleFaceTrackingIOS() {
	}
	
	public: void onReadyBRF() {
		brf::trace("ExampleFaceTrackingIOS::onReadyBRF");
		
		// setting up the face detection. Usually you are closer to a smartphone camera, than a
		// webcam on a PC, so we need to detect larger faces, instead of smaller ones.
		
		double border = 40.0;
		
		_faceDetectionROI.x = border;
		_faceDetectionROI.y = border;
		_faceDetectionROI.width = _bmd.width - border * 2;
		_faceDetectionROI.height = _bmd.height - border * 2;
		
		// setting up the face detection. Usually you are closer to a smartphone camera, than a
		// webcam on a PC, so we need to detect larger faces, instead of smaller ones.
		
		if(_bmd.width > 352) {
			// 640x480 settings
			_brfManager.setFaceDetectionVars(8.0, 0.5, 14.0, 0.06, 6, false);
		} else {
			// 352x288 settings
			_brfManager.setFaceDetectionVars(4.0, 0.5, 11.0, 0.06, 6, false);
		}
		
		// the face detection region of interest can be a bit smaller, than the overall roi.
		
		_brfManager.setFaceDetectionROI(_faceDetectionROI.x, _faceDetectionROI.y, _faceDetectionROI.width, _faceDetectionROI.height);
		
		// face tracking settings: min and max faceShape width
		
		_brfManager.setFaceTrackingVars(80, 500);
		
		// and candide tracking disabled in this example.
		
		_brfManager.candideEnabled(true);
		_brfManager.candideActionUnitsEnabled(true);
		
		// we want it all, so set the mode to face tracking, not just face detection or point tracking
		
		_brfManager.mode(brf::BRFMode::FACE_TRACKING);
		
		// and maybe turn off debug traces
		
		_brfManager.debug(false);
	}
	
	/**
	 * We update the sampled buffer with the BRF rois and results.
	 */
public: CGPoint* updateGUI(CGContextRef context) {
        int minY = 100;
        CGPoint points[68] = {};

		std::string& state = _brfManager.state();
	
		// Drawing the region of interest of BRF.
		DrawingUtils::drawRect(context, _brfRoi, false, 2, 0x00ff00, 1);
        

		// still looking for faces
		if(state == brf::BRFState::FACE_DETECTION) {
		
			// draw the region of interest for face detection
			DrawingUtils::drawRect(context, _faceDetectionROI, true, 1, 0xffff00, 1);
			
			// get all tracked face rectangles and draw them
			std::vector< std::shared_ptr<brf::Rectangle> >& rects = _brfManager.lastDetectedFaces();
			
			if(rects.size() > 0) {
				DrawingUtils::drawRects(context, rects, false, 1, 0x00ff00, 1);
			}
			
			// If enough faces were found, a merged face rect will be the result,
			// that starts the face analysis.
			
			brf::Rectangle& rect = _brfManager.lastDetectedFace();
			
			if(rect.x != 0.0) {
//				DrawingUtils::drawRect(context, rect, false, 3, 0xff7900, 1);
			}
            
		} else if(state == brf::BRFState::FACE_TRACKING_START || state == brf::BRFState::FACE_TRACKING) {
		
			brf::BRFFaceShape& faceShape = _brfManager.faceShape();
            
			
			// draw shape
            int i = 0;
            int l = (int)faceShape.points.size();
            
            while(i < l) {
                
                // Draw all points, invalid will be red (and will be removed instantly),
                // valid points are green.
                
                if(faceShape.points[i]) {
                    DrawingUtils::drawPoint(context, faceShape.points[i], 2.0f, true, 0x00ff00, 1);                    
                    double x = faceShape.points[i]->x;
                    double y = faceShape.points[i]->y;
                    points[i] = CGPointMake(x,y);
                   
                    std::string xs = std::to_string(points[i].x);
                    std::string ys = std::to_string(points[i].y);
                    std::string counti = std::to_string(i);
                    brf::trace("ExampleFaceTrackingIOS::i = "+counti+", x ="+xs);
                    brf::trace("ExampleFaceTrackingIOS::i = "+counti+", x = "+ys);
                } else {
//                    DrawingUtils::drawPoint(context, faceShape.points[i], 2.0f, true, 0xff0000, 1);
                }
                
                ++i;
            }
            
//            minY =  DrawingUtils::drawTriangles(context, faceShape.candideShapeVertices,
//                                                faceShape.candideShapeTriangles, true, 0x00ff00, 1);
			// draw surrounding rect
			
			DrawingUtils::drawRect(context, faceShape.bounds, false, 1, 0x00ff00, 1);
		}
        return points;
	}
};

#endif /* __brf__ios__ExampleFaceTrackingIOS__ */