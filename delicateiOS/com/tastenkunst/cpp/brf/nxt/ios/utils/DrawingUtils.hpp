#ifndef __brf__ios__DrawingUtils__
#define __brf__ios__DrawingUtils__

#import <UIKit/UIKit.h>
#include <vector>
#include <memory>
#include <string>

#include "com/tastenkunst/cpp/brf/nxt/utils/StringUtils.hpp"
#include "com/tastenkunst/cpp/brf/nxt/geom/Point.hpp"
#include "com/tastenkunst/cpp/brf/nxt/geom/Rectangle.hpp"

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor 						\
	colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
	green:((float)((rgbValue & 0xFF00) >> 8)) 			/ 255.0 \
	blue:((float)(rgbValue & 0xFF))						/ 255.0 \
	alpha:1.0]

//RGB color macro
#define UIColorFromRGBWithAlpha(rgbValue, a) [UIColor 			\
	colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
	green:((float)((rgbValue & 0xFF00) >> 8)) 			/ 255.0 \
	blue:((float)(rgbValue & 0xFF))						/ 255.0 \
	alpha:a]

class DrawingUtils {

	public: static double CANVAS_WIDTH;
	public: static double CANVAS_HEIGHT;

	public: static int drawTriangles(CGContextRef& context, std::vector< double >& vertices, std::vector< int >& triangle,
			bool clear = false, uint fillColor = 0xffff00, CGFloat fillAlpha = 1.0) {

		int i = 0;
		int l = (int)triangle.size();
        int minY = 999;
        int index = 0;
        
		CGContextSetLineWidth(context, 2.0);
		CGColorRef color = UIColorFromRGBWithAlpha(fillColor, fillAlpha).CGColor;
		CGContextSetStrokeColorWithColor(context, color);
        
        CGColorRef colors[] = {
            UIColorFromRGBWithAlpha(0xFFFC00, fillAlpha).CGColor,
        UIColorFromRGBWithAlpha(0xFF001A, fillAlpha).CGColor,
        UIColorFromRGBWithAlpha(0x1A00FF, fillAlpha).CGColor,
        UIColorFromRGBWithAlpha(0xffffff, fillAlpha).CGColor,
        UIColorFromRGBWithAlpha(0x000000, fillAlpha).CGColor};
        int faceBounds[] = {0,20,22,24,28,56,58,60,64,88,90,94,122,124,126,130};
        CGContextSetFillColorWithColor(context, color);
//        while (m < 226){
////            CGContextSetFillColorWithColor(context, colors[cCount++]);
//            CGFloat xx0 = vertices[m];
//            CGFloat yy0 = CANVAS_HEIGHT - vertices[m+1];
//
//            CGRect rectangle = CGRectMake(xx0, yy0, 10, 10);
//            CGContextAddEllipseInRect(context, rectangle);
//            CGContextFillPath(context);
//            
//            brf::trace("the draw candidepoint  = "+brf::to_string(m));
//            m+=2;
//        }
        
        //confirm
        int position = 0;
        while (position < 16){
            CGFloat xx0 = vertices[faceBounds[position]];
            CGFloat yy0 = CANVAS_HEIGHT - vertices[faceBounds[position]+1];
//            CGFloat xx0 = vertices[62];
//            CGFloat yy0 = CANVAS_HEIGHT - vertices[63];
            CGRect rectangle = CGRectMake(xx0, yy0, 10, 10);
            CGContextAddEllipseInRect(context, rectangle);
            CGContextFillPath(context);
//            brf::trace("the draw candidepoint  = "+brf::to_string(ranges[m]));
            position++;
        }
        
		while(i < l) {
			int ti0 = triangle[i];
			int ti1 = triangle[i + 1];
			int ti2 = triangle[i + 2];
            
//            brf::trace("the ti0 = "+brf::to_string(ti0)+" , i = "+brf::to_string(i));
//            brf::trace("the ti1 = "+brf::to_string(ti1)+" , i = "+brf::to_string(i+1));
//            brf::trace("the ti2 = "+brf::to_string(ti2)+" , i = "+brf::to_string(i+2));

			CGFloat x0 = vertices[ti0 * 2];
			CGFloat y0 = CANVAS_HEIGHT - vertices[ti0 * 2 + 1];
			CGFloat x1 = vertices[ti1 * 2];
			CGFloat y1 = CANVAS_HEIGHT - vertices[ti1 * 2 + 1];
			CGFloat x2 = vertices[ti2 * 2];
			CGFloat y2 = CANVAS_HEIGHT - vertices[ti2 * 2 + 1];
            
//            brf::trace("the ti0 = "+brf::to_string(ti0)+" , i = "+brf::to_string(i));
//            brf::trace("the ti1 = "+brf::to_string(ti1)+" , i = "+brf::to_string(i+1));
//            brf::trace("the ti2 = "+brf::to_string(ti2)+" , i = "+brf::to_string(i+2));
            
            if(minY > vertices[ti0 * 2 + 1]){
                minY = vertices[ti0 * 2 + 1];
                index = ti0 * 2 + 1;
            }
            
            if(minY > vertices[ti1 * 2 + 1]){
                minY = vertices[ti1 * 2 + 1];
                index = ti1 * 2 + 1;
            }
            
            if(minY > vertices[ti2 * 2 + 1]){
                minY = vertices[ti2 * 2 + 1];
                index = ti2 * 2 + 1;
            }
			
			if(isnan(x0) || isnan(y0) || isnan(x1) || isnan(y1) || isnan(x2) || isnan(y2)) {
				brf::trace("isnan: " +
					brf::to_string(x0) + " " + brf::to_string(y0) + " "  +
					brf::to_string(x1) + " " + brf::to_string(y1) + " "  +
					brf::to_string(x2) + " " + brf::to_string(y2));
			} else {
//				CGContextMoveToPoint(context, x0, y0);
//				CGContextAddLineToPoint(context, x1, y1);
//				CGContextAddLineToPoint(context, x2, y2);
//				CGContextAddLineToPoint(context, x0, y0);

			}
			
			i+=3;
		}
//		brf::trace("the minY = "+brf::to_string(minY));
        brf::trace("the vertice's index = "+brf::to_string(index));
		CGContextStrokePath(context);
        return minY;
	}
	
	public: static void drawTrianglesWithTexture(CGContextRef& context, std::vector< double >& vertices, std::vector< int >& triangle,
			bool clear = false, uint fillColor = 0xffff00, CGFloat fillAlpha = 1.0) {

		int i = 0;
		int l = (int)triangle.size();
		
		CGContextSetLineWidth(context, 1.0);
		CGColorRef color = UIColorFromRGBWithAlpha(fillColor, fillAlpha).CGColor;
		CGContextSetStrokeColorWithColor(context, color);
	
		while(i < l) {
			int ti0 = triangle[i];
			int ti1 = triangle[i + 1];
			int ti2 = triangle[i + 2];

			CGFloat x0 = vertices[ti0 * 2];
			CGFloat y0 = CANVAS_HEIGHT - vertices[ti0 * 2 + 1];
			CGFloat x1 = vertices[ti1 * 2];
			CGFloat y1 = CANVAS_HEIGHT - vertices[ti1 * 2 + 1];
			CGFloat x2 = vertices[ti2 * 2];
			CGFloat y2 = CANVAS_HEIGHT - vertices[ti2 * 2 + 1];
			
			if(isnan(x0) || isnan(y0) || isnan(x1) || isnan(y1) || isnan(x2) || isnan(y2)) {
				brf::trace("isnan: " +
					brf::to_string(x0) + " " + brf::to_string(y0) + " "  +
					brf::to_string(x1) + " " + brf::to_string(y1) + " "  +
					brf::to_string(x2) + " " + brf::to_string(y2));
			} else {
				CGContextMoveToPoint(context, x0, y0);
				CGContextAddLineToPoint(context, x1, y1);
				CGContextAddLineToPoint(context, x2, y2);
				CGContextAddLineToPoint(context, x0, y0);
			}
			
			i+=3;
		}
		
		CGContextStrokePath(context);
	}
	
	public: static void drawRect(CGContextRef& context, std::shared_ptr<brf::Rectangle> rect,
			bool clear = false, CGFloat lineThickness = 1.0, uint lineColor = 0xffff00, CGFloat lineAlpha = 1.0) {
		
		CGContextSetLineWidth(context, lineThickness);
		CGColorRef color = UIColorFromRGBWithAlpha(lineColor, lineAlpha).CGColor;
		CGContextSetStrokeColorWithColor(context, color);

        CGRect rectangle = CGRectMake(rect->x, CANVAS_HEIGHT - rect->y - rect->height, rect->width, rect->height);

        CGContextAddRect(context, rectangle);
        CGContextStrokePath(context);
	}

	public: static void drawRect(CGContextRef& context, brf::Rectangle& rect,
			bool clear = false, CGFloat lineThickness = 1.0, uint lineColor = 0xffff00, CGFloat lineAlpha = 1.0) {
					
		CGContextSetLineWidth(context, lineThickness);
		CGColorRef color = UIColorFromRGBWithAlpha(lineColor, lineAlpha).CGColor;
		CGContextSetStrokeColorWithColor(context, color);

        CGRect rectangle = CGRectMake(rect.x, CANVAS_HEIGHT - rect.y - rect.height, rect.width, rect.height);

        CGContextAddRect(context, rectangle);
        CGContextStrokePath(context);
	}

	public: static void drawRects(CGContextRef& context, std::vector< std::shared_ptr<brf::Rectangle> >& rects,
			bool clear = false, CGFloat lineThickness = 1.0, uint lineColor = 0xffff00, CGFloat lineAlpha = 1.0) {

		CGContextSetLineWidth(context, lineThickness);
		CGColorRef color = UIColorFromRGBWithAlpha(lineColor, lineAlpha).CGColor;
		CGContextSetStrokeColorWithColor(context, color);

        CGRect rectangle = CGRectMake(0,0,1,1);

		int i = 0;
		int l = (int)rects.size();
		std::shared_ptr<brf::Rectangle> rect;

		for(; i < l; i++) {
			rect = rects[i];

			rectangle.origin.x = rect->x;
			rectangle.origin.y = CANVAS_HEIGHT - rect->y - rect->height;
			rectangle.size.width = rect->width;
			rectangle.size.height = rect->height;

	        CGContextAddRect(context, rectangle);
		}
		
        CGContextStrokePath(context);
	}

	public: static void drawPoint(CGContextRef& context, brf::Point& point, CGFloat radius,
			bool clear = false, uint fillColor = 0xffff00, CGFloat fillAlpha = 1.0) {

		CGColorRef color = UIColorFromRGBWithAlpha(fillColor, fillAlpha).CGColor;
		CGContextSetFillColorWithColor(context, color);
		
        CGRect rectangle = CGRectMake(point.x - radius, CANVAS_HEIGHT - point.y - radius, radius * 2.0, radius * 2.0);
		
		CGContextAddEllipseInRect(context, rectangle);
		CGContextFillPath(context);
	}

	public: static void drawPoint(CGContextRef& context, std::shared_ptr<brf::Point> point, CGFloat radius,
			bool clear = false, uint fillColor = 0xffff00, CGFloat fillAlpha = 1.0) {

		CGColorRef color = UIColorFromRGBWithAlpha(fillColor, fillAlpha).CGColor;
		CGContextSetFillColorWithColor(context, color);
		
        CGRect rectangle = CGRectMake(point->x - radius, CANVAS_HEIGHT - point->y - radius, radius * 2.0, radius * 2.0);
		
		CGContextAddEllipseInRect(context, rectangle);
		CGContextFillPath(context);
	}

	public: static void drawPoints(CGContextRef& context, std::vector< std::shared_ptr<brf::Point> >& points, CGFloat radius,
			bool clear = false, uint fillColor = 0xffff00, CGFloat fillAlpha = 1.0) {

		CGColorRef color = UIColorFromRGBWithAlpha(fillColor, fillAlpha).CGColor;
		CGContextSetFillColorWithColor(context, color);

        CGRect rectangle = CGRectMake(0, 0, radius * 2.0, radius * 2.0);
		
		int i = 0;
		int l = (int)points.size();
		std::shared_ptr<brf::Point> point;

		for(; i < l; i++) {
			point = points[i];
			
			rectangle.origin.x = point->x - radius;
			rectangle.origin.y = CANVAS_HEIGHT - point->y - radius;
			
			CGContextAddEllipseInRect(context, rectangle);
		}

		CGContextFillPath(context);
	}
};

#endif /* __brf__ios__DrawingUtils__ */
