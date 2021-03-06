//
//  ScaleView.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/19.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

class ScaleView: UIScrollView,UIScrollViewDelegate{
    
    let Mytag = 2
    var currentSubView: BasicDrawerView? {
        didSet{
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingScrollView()
    }
    
    private func settingScrollView(){
        tag = Mytag
        delegate = self
        minimumZoomScale = 0.5
        maximumZoomScale = 1.3
        zoomScale = 1;
        contentSize = frame.size
    }
    
    func addDrawerView(view: BasicDrawerView) {
        super.addSubview(view)
        centerScrollViewContents(view)
        currentSubView = view
    }
    
    func cleanAllViews(){
        for subView in subviews{
            if subView.tag == 1 {
                subView.removeFromSuperview()
            }
        }
    }
    
    func centerScrollViewContents(view: UIView) {
        let boundsSize = bounds.size
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScaleView{
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        contentSize = frame.size
        return currentSubView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        contentSize = frame.size
        centerScrollViewContents(currentSubView!)
    }
}
