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
	@IBOutlet var popupImage:UIImageView!
	@IBOutlet var topButton:UIButton!
	@IBOutlet var bottomButton:UIButton!
	
	var restartGameCallback:((PopupView?)->())?;
	var quitGameCallback:((PopupView?)->())?;
	
	let animationDuration = 0.4;
	
	enum PopupType:String
	{
		case Win = "Popup - Win";
		case CannotPlace = "Popup - Cannot Place";
		case CannotRemove = "Popup - Cannot Remove";
		case Restart = "Popup - Restart";
	}
	
	func close()
	{
		let blur = self.superview?.superview;
		UIView.animateWithDuration(animationDuration, animations:
			{
				() -> () in
				blur?.alpha = 0.0;
				self.transform = CGAffineTransformMakeScale(0, 0);
				return;
			}, completion:
			{
				(Bool) -> () in
				blur?.removeFromSuperview();
				return;
			});
	}

	class func showPopup(#type:PopupType, onView container:UIView) -> PopupView
	{
		let popupBlur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark));
		popupBlur.frame = container.frame;
		
		let popup = NSBundle.mainBundle().loadNibNamed("PopupView", owner: nil, options: nil)[0] as PopupView;
		popup.frame = popupBlur.frame;
		popup.center = popupBlur.center;
		popupBlur.contentView.addSubview(popup);
		
		if let imageView = popup.popupImage
		{
			imageView.image = UIImage(named: type.toRaw());
		}
		
		switch type
		{
			case PopupView.PopupType.Restart:
				popup.topButton.setImage(UIImage(named: "Button - Restart"), forState: UIControlState.Normal);
				popup.bottomButton.setImage(UIImage(named: "Button - Menu"), forState: UIControlState.Normal);
				break;
			
			default:
				break;
		}
		
		popupBlur.alpha = 0;
		popup.transform = CGAffineTransformMakeScale(0, 0);
		container.addSubview(popupBlur);
		
		UIView.animateWithDuration(popup.animationDuration, animations:
			{
				() -> () in
				popupBlur.alpha = 1.0;
				popup.transform = CGAffineTransformMakeScale(1.0, 1.0);
			});
		
		return popup;
	}
	
	@IBAction func restartGame()
	{
		if let fn = self.restartGameCallback
		{
			fn(self);
		}
	}
	
	@IBAction func quitGame()
	{
		if let fn = self.quitGameCallback
		{
			fn(self);
		}
	}
}
