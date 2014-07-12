//
//  PopupView.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 7/11/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

class PopupView:UIView
{
	@IBOutlet var popupImage:UIImageView?
	@IBOutlet var topButton:UIButton?
	@IBOutlet var bottomButton:UIButton?
	
	enum PopupType:String
	{
		case Win = "Popup - Win";
	}

	class func showPopup(#type:PopupType, onView container:UIView)
	{
		let popupBlur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark));
		popupBlur.frame = container.frame;
		container.addSubview(popupBlur);
		
		let popup = NSBundle.mainBundle().loadNibNamed("PopupView", owner: nil, options: nil)[0] as PopupView;
		popup.center = popupBlur.center;
		popupBlur.contentView.addSubview(popup);
		
		switch type
		{
			case PopupView.PopupType.Win:
				if let imageView = popup.popupImage
				{
					imageView.image = UIImage(named: "Popup - Cannot Remove");
				}
				popup.topButton?.addTarget(popup, action: "restartGame", forControlEvents: UIControlEvents.TouchUpInside);
				popup.bottomButton?.addTarget(popup, action: "quitGame", forControlEvents: UIControlEvents.TouchUpInside);
				break;
			
			default:
				break;
		}
	}
	
	@IBAction func restartGame()
	{
		print("Restart game");
	}
	
	@IBAction func quitGame()
	{
		print("Quit game");
	}
}
