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
		let suitColor = (card.suit == Card.Suit.Diamond || card.suit == Card.Suit.Heart ? UIColor.redColor() : UIColor.blackColor());
		
		//let template = UIImage.tintedImage(named: "Card Template", tint:suitColor);
		let template = UIImage(named: "Card Template");
		let suit = UIImage.tintedImage(named: "Suit - \(card.suit.toRaw())", tint:suitColor);
		let rank = UIImage.tintedImage(named: "Rank - \(card.rank.toRaw())", tint:UIColor.whiteColor());
		
		UIGraphicsBeginImageContext(template.size);
		let context = UIGraphicsGetCurrentContext();
		
		template.drawAtPoint(CGPoint(x: 0, y: 0));
		
		var rankX = 75 - (rank.size.width / 2.0);
		var rankY = 87.5 - (rank.size.height / 2.0);
		rank.drawAtPoint(CGPoint(x: rankX, y: rankY));
		
		rankX = template.size.width - rankX - rank.size.width;
		rankY = template.size.height - rankY - rank.size.height;
		rank.drawAtPoint(CGPoint(x: rankX, y: rankY));
		
		var suitX = (template.size.width - suit.size.width) / 2.0;
		var suitY = (template.size.height - suit.size.height) / 2.0;
		suit.drawAtPoint(CGPoint(x: suitX, y: suitY));
		
		let final = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		return final;
	}
}