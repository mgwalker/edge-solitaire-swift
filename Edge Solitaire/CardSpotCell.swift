//
//  CardSpotCell.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 7/6/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

class CardSpotCell:UICollectionViewCell
{
	@IBOutlet var imageView:UIImageView;

	@IBOutlet var cardImage:UIImageView;
	@IBOutlet var markerImage:UIImageView;
	
	var modeController:GameModeControllerProtocol?;
	var index:Int = 0;
	var isSelected:Bool = false
	{
		didSet
		{
			if isSelected
			{
				self.layer.borderColor = UIColor.yellowColor().CGColor;
				self.layer.cornerRadius = 10;
				self.layer.borderWidth = 5;
			}
			else
			{
				self.layer.borderColor = UIColor.clearColor().CGColor;
			}
		}
	}
	var card:Card?
	{
		didSet
		{
			if card
			{
				self.cardImage.image = CardHelper.imageForCard(card!);
			}
		}
	}
	var value:Int
	{
		get
		{
			if self.card && self.modeController
			{
				return self.modeController!.valueOfCard(self.card!);
			}
			return 0;
		}
	}
	
	func clearCard()
	{
		UIView.animateWithDuration(0.15, animations:
			{
				()->Void in
				self.cardImage.alpha = 0;
			}, completion:
			{
				(Bool)->Void in
				self.cardImage.image = nil;
				self.cardImage.alpha = 1;
				self.isSelected = false;
				self.card = nil;
			}
		);
	}
}
