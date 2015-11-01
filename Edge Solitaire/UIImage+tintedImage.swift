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
	// Loads an image and colors its opaque portions with
	// the specified tint color.
	class func tintedImage(named imageName:String, tint:UIColor) -> UIImage?
	{
		// Load the image
		if let source = UIImage(named: imageName)
		{
			// Start a graphics context
			UIGraphicsBeginImageContext(source.size);
			let context = UIGraphicsGetCurrentContext();
			
			// Flip the draw upside down.  Contexts draw from
			// the opposite direction as images because let's
			// not have consistency or anything.
			CGContextTranslateCTM(context, 0, source.size.height);
			CGContextScaleCTM(context, 1.0, -1.0);
			
			let rect = CGRectMake(0, 0, source.size.width, source.size.height);
			
			// Draw the image as a mask.
			CGContextSetBlendMode(context, CGBlendMode.Normal);
			CGContextDrawImage(context, rect, source.CGImage);
			
			// And now paint in the tint color blended with
			// the mask.  Hooray!
			CGContextSetBlendMode(context, CGBlendMode.SourceIn);
			tint.setFill();
			CGContextFillRect(context, rect);
			
			// Now pull the context into an image and send it back.
			let tintedImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			return tintedImage;
		}
		return nil;
	}
}
