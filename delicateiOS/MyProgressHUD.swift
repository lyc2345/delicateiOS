//
//  MyProgressD.swift
//  GoPurpose
//
//  Created by John Wu on 2016/7/29.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

class MyProgressHUD: UIActivityIndicatorView{
    
    override init(activityIndicatorStyle style: UIActivityIndicatorViewStyle) {
        super.init(activityIndicatorStyle: style)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func showOn(view: UIView,frame: CGRect){
        let indicator = MyProgressHUD(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.frame = frame
        indicator.backgroundColor = UIColor.whiteColor()
        indicator.layer.cornerRadius = 10
        indicator.center = view.center;
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        indicator.startAnimating()
    }
    
    class func hideForView(view: UIView){
        let indicator = self.HUDForView(view)
        if indicator != nil {
            indicator?.hidden = true
        }
    }
    
    class func removeForView(view: UIView){
        let indicator = self.HUDForView(view)
        if indicator != nil {
            indicator?.removeFromSuperview()
        }
    }
    
    class func HUDForView(view: UIView) -> MyProgressHUD?{
        let subviews :NSArray = view.subviews
        let subviewsEnum = subviews.reverseObjectEnumerator()
        for subview in subviewsEnum {
            if subview.isKindOfClass(self) {
                return subview as? MyProgressHUD;
            }
        }
        return nil
    }
}

