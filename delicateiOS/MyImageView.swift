//
//  MyImageView.swift
//  delicateiOS
//
//  Created by John Wu on 2016/10/21.
//  Copyright © 2016年 John Wu. All rights reserved.
//

import UIKit

protocol MyImageViewDelegate{
    func showingBy(image: UIImage)
}

class MyImageView: UIImageView{
    
    var hasImage: Bool = false
    
    override var image: UIImage?{
        didSet{
            hasImage = true
        }
    }
    
    var delegate: MyImageViewDelegate? {
        didSet{
            let gesture = UITapGestureRecognizer(target: self, action: #selector(MyImageView.click))
            addGestureRecognizer(gesture)
        }
    }
    
    func click(){
        if(hasImage){
            delegate!.showingBy(self.image!)
        }
    }
}
