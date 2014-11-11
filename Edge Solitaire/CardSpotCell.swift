//
//  CardSpotCell.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 7/6/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

// Collection view cell representing a card spot
class CardSpotCell:UICollectionViewCell
{
	// Marker (i.e., the king, queen, and jack markers) and
	// card images.
	@IBOutlet var cardImage:UIImageView!;
	@IBOutlet var markerImage:UIImageView!;
	
	var index:Int = 0;								// Cell index in the container
	
	// Whether or not the cell is currently selected.
	var isSelected:Bool = false
	{
		didSet
		{
			// When the cell switches to selected,
			// setup the border.
			if isSelected
			{
				self.layer.borderColor = UIColor.yellowColor().CGColor;
				//self.layer.cornerRadius = 10;
				self.layer.borderWidth = 5;
			}
			// When the cell switches to unselected,
			// remove the border.
			else
			{
				self.layer.borderColor = UIColor.clearColor().CGColor;
			}
		}
	}
	
	// The card attached to the cell.  Optional.
	var card:Card?
	{
		didSet
		{
			// If a card is being added, set the card image.
			if card != nil
			{
				self.cardImage.image = card!.image;
			}
			// Otherwise, clear the card image.
			else
			{
				self.cardImage.image = nil;
			}
		}
	}
	
	// Clear the currently attached card.
	func clearCard()
	{
		UIView.animateWithDuration(0.15, animations:
			{
				// Fade the card image out.
				()->Void in
				self.cardImage.alpha = 0;
				return;
			}, completion:
			{
				// And then clear it, reset the alpha, clear
				// the cell's selection, and remove the card
				// from the cell object.
				(Bool)->Void in
				self.cardImage.image = nil;
				self.cardImage.alpha = 1;
				self.isSelected = false;
				self.card = nil;
				return;
			}
		);
	}
}
