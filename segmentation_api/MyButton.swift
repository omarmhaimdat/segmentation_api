//
//  MyButton.swift
//  segmentation_api
//
//  Created by M'haimdat omar on 21-05-2020.
//  Copyright © 2020 M'haimdat omar. All rights reserved.
//

import UIKit

class MyButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.white.cgColor
        setTitleColor(#colorLiteral(red: 0.5, green: 0.06049922854, blue: 0.07871029526, alpha: 1), for: .normal)
        titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25)
        layer.borderColor = #colorLiteral(red: 0.5, green: 0.06049922854, blue: 0.07871029526, alpha: 1).cgColor
        layer.cornerRadius = 30
        setTitle("Upload an image", for: .normal)
        let icon = UIImage(systemName: "square.and.arrow.up")?.resized(newSize: CGSize(width: 35, height: 35))
        
        let newIcon = icon?.withTintColor(#colorLiteral(red: 0.5, green: 0.06049922854, blue: 0.07871029526, alpha: 1))
        self.setImage( newIcon, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 100)
        self.layoutIfNeeded()
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        contentHorizontalAlignment = .center
        layer.shadowOpacity = 0.4
        layer.shadowColor = #colorLiteral(red: 0.5, green: 0.06049922854, blue: 0.07871029526, alpha: 1).cgColor
        layer.shadowRadius = 10
        layer.masksToBounds = true
        clipsToBounds = false
        titleEdgeInsets.left = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {
    
    func resized(newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
