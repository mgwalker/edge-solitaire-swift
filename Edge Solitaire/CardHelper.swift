//
//  CardHelper.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 7/6/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

// This will all get refactored.  It just provides
// a way to get an image for a card.
class CardHelper
{
	// Composites card blank, border, rank, and suit
	// images together into a card image.
	class func imageForCard(card:Card) -> UIImage
	{
		var suitColor = UIColor.blackColor();
		var templateColor = UIColor.blackColor();
		
		if card.suit == Card.Suit.Diamond || card.suit == Card.Suit.Heart
		{
			suitColor = UIColor(red: 0.85, green: 0, blue: 0, alpha: 1.0);
			templateColor = UIColor(red: 0.4, green: 0, blue: 0, alpha: 1.0);
		}
		
		let blank = UIImage.tintedImage(named: "Card Blank", tint: UIColor.whiteColor());
		let template = UIImage.tintedImage(named: "Card Template", tint:templateColor);
		let suit = UIImage.tintedImage(named: "Suit - \(card.suit.toRaw())", tint:suitColor);
		let rank = UIImage.tintedImage(named: "Rank - \(card.rank.toRaw())", tint:UIColor.whiteColor());
		
		UIGraphicsBeginImageContext(template.size);
		let context = UIGraphicsGetCurrentContext();
		
		blank.drawAtPoint(CGPoint(x: 0, y: 0));
		template.drawAtPoint(CGPoint(x: 0, y: 0));
		
		var rankX = 75 - (rank.size.width / 2.0);
		var rankY = 87.5 - (rank.size.height / 2.0);
		rank.drawAtPoint(CGPoint(x: rankX, y: rankY));
		
		rankX = template.size.width - rankX - rank.size.width;
		rankY = template.size.height - rankY - rank.size.height;
		rank.drawAtPoint(CGPoint(x: rankX, y: rankY));
		
		let rankValue = card.rank.toRaw();
		
		let centerX = (template.size.width - suit.size.width) / 2.0;
		let centerY = (template.size.height - suit.size.height) / 2.0;
		
		if rankValue > 1 && rankValue < 11
		{
			let suitWidth = suit.size.width;
			let suitHalfWidth = suitWidth / 2.0;
			let suitHeight = suit.size.height;
			let suitHalfHeight = suitHeight / 2.0;
			
			if rankValue == 3 || rankValue == 5 || rankValue == 9
			{
				// center, center
				suit.drawAtPoint(CGPoint(x: centerX, y: centerY));
			}
			if rankValue == 2 || rankValue == 3
			{
				// center, top and bottom
				suit.drawAtPoint(CGPoint(x: centerX, y: centerY - suitHeight - suitHalfHeight));
				suit.drawAtPoint(CGPoint(x: centerX, y: centerY + suitHeight + suitHalfHeight));
			}
			if rankValue == 5 || rankValue == 4
			{
				// corners
				suit.drawAtPoint(CGPoint(x: centerX - suitWidth, y: centerY - suitHeight - suitHalfHeight));
				suit.drawAtPoint(CGPoint(x: centerX + suitWidth, y: centerY - suitHeight - suitHalfHeight));
				suit.drawAtPoint(CGPoint(x: centerX - suitWidth, y: centerY + suitHeight + suitHalfHeight));
				suit.drawAtPoint(CGPoint(x: centerX + suitWidth, y: centerY + suitHeight + suitHalfHeight));
			}
			if rankValue == 6 || rankValue == 7
			{
				// columns of three
				suit.drawAtPoint(CGPoint(x: centerX - suitWidth, y: centerY - suitHeight - suitHalfHeight));
				suit.drawAtPoint(CGPoint(x: centerX + suitWidth, y: centerY - suitHeight - suitHalfHeight));
				suit.drawAtPoint(CGPoint(x: centerX - suitWidth, y: centerY));
				suit.drawAtPoint(CGPoint(x: centerX + suitWidth, y: centerY));
				suit.drawAtPoint(CGPoint(x: centerX - suitWidth, y: centerY + suitHeight + suitHalfHeight));
				suit.drawAtPoint(CGPoint(x: centerX + suitWidth, y: centerY + suitHeight + suitHalfHeight));
			}
			if rankValue == 7
			{
				suit.drawAtPoint(CGPoint(x: centerX, y: centerY - suitHeight));
			}
			if rankValue == 8 || rankValue == 9 || rankValue == 10
			{
				// columns of four
				suit.drawAtPoint(CGPoint(x: centerX - suitWidth, y: centerY - suitHalfHeight - suitHeight));
				suit.drawAtPoint(CGPoint(x: centerX - suitWidth, y: centerY - suitHalfHeight));
				suit.drawAtPoint(CGPoint(x: centerX - suitWidth, y: centerY + suitHalfHeight));
				suit.drawAtPoint(CGPoint(x: centerX - suitWidth, y: centerY + suitHalfHeight + suitHeight));
				suit.drawAtPoint(CGPoint(x: centerX + suitWidth, y: centerY - suitHalfHeight - suitHeight));
				suit.drawAtPoint(CGPoint(x: centerX + suitWidth, y: centerY - suitHalfHeight));
				suit.drawAtPoint(CGPoint(x: centerX + suitWidth, y: centerY + suitHalfHeight));
				suit.drawAtPoint(CGPoint(x: centerX + suitWidth, y: centerY + suitHalfHeight + suitHeight));
			}
			if rankValue == 10
			{
				suit.drawAtPoint(CGPoint(x: centerX, y: centerY - suitHeight));
				suit.drawAtPoint(CGPoint(x: centerX, y: centerY + suitHeight));
			}
		}
		else if card.rank == Card.Rank.Ace
		{
			let ace = UIImage.tintedImage(named: "Face - 1\(card.suit.toRaw())", tint: suitColor);
			ace.drawAtPoint(CGPoint(
				x: (template.size.width - ace.size.width) / 2.0,
				y: (template.size.height - ace.size.height) / 2.0));
		}
		else if rankValue > 10
		{
			let degrees:Double = (card.rank == Card.Rank.Jack ? 181 : (card.rank == Card.Rank.Queen ? 271 : 360));
			for var angle:Double = 0; angle < degrees; angle += 22.5
			{
				var rad = (angle / 180.0) * Double(M_PI);
				var x:Float = (Float(cos(rad)) * Float(suit.size.width) * 1.5) + Float(centerX);
				var y:Float = (Float(sin(rad)) * Float(suit.size.height) * 1.5) + Float(centerY);
				suit.drawAtPoint(CGPoint(x: CGFloat(x), y: CGFloat(y)));
			}
		}
		
		let final = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		return final;
	}
}
