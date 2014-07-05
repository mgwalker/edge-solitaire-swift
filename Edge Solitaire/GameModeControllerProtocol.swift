//
//  GameModeProtocol.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 6/10/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import Foundation
import UIKit

class CardSpot: UIImageView
{
}

enum GameMode:String
{
	case KingsInTheCorner = "KINGS IN THE CORNER", RoyalsOnEdge = "ROYALS ON EDGE", FamiliesDivided = "FAMILIES DIVIDED";
}

protocol GameModeControllerProtocol
{
}

class GameModeFactory
{
	class func GetGameMode(mode: GameMode) -> GameModeControllerProtocol?
	{
		switch mode
		{
			case .KingsInTheCorner:
				return KingsInTheCornerModeController();
			
			default:
				return nil;
			
		}
	}
}

class KingsInTheCornerModeController: GameModeControllerProtocol
{
}

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

class CardHelper
{
	class func imageForCard(card:Card) -> UIImage
	{
		let suitColor = (card.suit == Card.Suit.Diamond || card.suit == Card.Suit.Heart ?
			UIColor(red: 0.75, green: 0, blue: 0, alpha: 1.0) : UIColor.blackColor());
		
		let blank = UIImage.tintedImage(named: "Card Blank", tint: UIColor.whiteColor());
		let template = UIImage.tintedImage(named: "Card Template", tint:suitColor);
		//let template = UIImage(named: "Card Template");
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
				var x = (Float(cos(rad)) * suit.size.width * 1.5) + centerX;
				var y = (Float(sin(rad)) * suit.size.height * 1.5) + centerY;
				suit.drawAtPoint(CGPoint(x: x, y: y));
			}
		}
		
		let final = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		return final;
	}
}