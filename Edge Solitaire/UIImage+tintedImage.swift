//
//  UIImage+tintedImage.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 7/6/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

extension UIImage
{
	class func tintedImage(named imageName:String, tint:UIColor) -> UIImage
	{
		let source = UIImage(named: imageName);
		
		UIGraphicsBeginImageContext(source.size);
		let context = UIGraphicsGetCurrentContext();
		
		CGContextTranslateCTM(context, 0, source.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		let rect = CGRectMake(0, 0, source.size.width, source.size.height);
		
		CGContextSetBlendMode(context, kCGBlendModeNormal);
		CGContextDrawImage(context, rect, source.CGImage);
		
		CGContextSetBlendMode(context, kCGBlendModeSourceIn);
		tint.setFill();
		CGContextFillRect(context, rect);
		
		let tintedImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		return tintedImage;
	}
}
