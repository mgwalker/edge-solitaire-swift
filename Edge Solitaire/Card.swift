//
//  Card.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 6/10/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

func ==(lhs:Card, rhs:Card) -> Bool
{
	return lhs.hashValue == rhs.hashValue;
}

class Card : Hashable
{
	enum Suit:Character
	{
		case Club = "♣", Diamond = "♦", Heart = "♥", Spade = "♠";
		
		// It'd be neat if we could iterate over the possible values
		// of an enum, but we can't, so we'll do this to get all of
		// the possible values.
		static func all() -> [Suit]
		{
			return [
				Suit.Club, Suit.Diamond, Suit.Heart, Suit.Spade
			];
		}
	}
	
	enum Rank:Int
	{
		case Ace = 1;
		case Two, Three, Four, Five;
		case Six, Seven, Eight, Nine;
		case Ten, Jack, Queen, King;
		
		// And again with the list of enum values.  This is actually
		// not what you'd normally do, but doing this lets us have
		// a loop over the values when building a deck (below)
		// rather than explicitly referencing each value.
		static func all() -> [Rank]
		{
			return [
				Rank.Ace, Rank.Two, Rank.Three, Rank.Four,
				Rank.Five, Rank.Six, Rank.Seven, Rank.Eight,
				Rank.Nine, Rank.Ten, Rank.Jack, Rank.Queen,
				Rank.King
			];
		}
	}
	
	let suit:Suit;	// Card's suit and
	let rank:Rank;	// rank.  Constants.
	
	init(suit:Suit, rank:Rank)
	{
		self.suit = suit;
		self.rank = rank;
	}

	// Convenience method to create a new deck of cards,
	// optionally shuffled.
	class func newDeck<CardType: Card>(shuffle shuffled:Bool = true) -> [CardType]
	{
		var cards:[CardType] = [CardType]();
		for suit in Suit.all()
		{
			for rank in Rank.all()
			{
				cards += [ CardType(suit:suit, rank:rank) ];
			}
		}

		if shuffled
		{
			cards = Card.shuffle(cards);
		}
		
		return cards;
	}
	
	// Shuffle method.  Implementes Fisher-Yates algorithm.
	class func shuffle<CardType:Card>(var cards:[CardType]) -> [CardType]
	{
		for i in 0..<cards.count
		{
			let swap = Int(arc4random_uniform(52 - UInt32(i)));
			var temp = cards[51 - i];
			cards[51 - i] = cards[swap];
			cards[swap] = temp;
		}
		
		return cards;
	}
	
	var hashValue : Int {
		get {
			
			var offset = 0;
			switch(self.suit)
			{
				case .Club:
					offset = 0;
					break;
					
				case .Diamond:
					offset = 13;
					break;
					
				case .Heart:
					offset = 26;
					break;
					
				case .Spade:
					offset = 39;
					break;
			}

			return self.rank.rawValue + offset;
		}
	}
	// Composites card blank, border, rank, and suit
	// images together into a card image.
	var image:UIImage
		{
		get
		{
			var documentURL = NSFileManager.defaultManager().URLForDirectory(
				NSSearchPathDirectory.ApplicationSupportDirectory,
				inDomain: NSSearchPathDomainMask.UserDomainMask,
				appropriateForURL: nil,
				create: true,
				error: nil)!;
			
			// set1 is here so we can add more card sets later, perhaps,
			// without having to re-generate anything
			documentURL = documentURL.URLByAppendingPathComponent("set1-\(self.hashValue).png");
			
			if NSFileManager.defaultManager().fileExistsAtPath(documentURL.path!)
			{
				return UIImage(contentsOfFile: documentURL.path!)!;
			}

			var suitColor = UIColor.blackColor();
			var templateColor = UIColor.blackColor();
			
			if self.suit == Card.Suit.Diamond || self.suit == Card.Suit.Heart
			{
				suitColor = UIColor(red: 0.85, green: 0, blue: 0, alpha: 1.0);
				templateColor = UIColor(red: 0.4, green: 0, blue: 0, alpha: 1.0);
			}
			
			let blank = UIImage.tintedImage(named: "Card Blank", tint: UIColor.whiteColor())!;
			let template = UIImage.tintedImage(named: "Card Template", tint:templateColor)!;
			let suit = UIImage.tintedImage(named: "Suit - \(self.suit.rawValue)", tint:suitColor)!;
			let rank = UIImage.tintedImage(named: "Rank - \(self.rank.rawValue)", tint:UIColor.whiteColor())!;
			
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
			
			let rankValue = self.rank.rawValue;
			
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
			else if self.rank == Card.Rank.Ace
			{
				let ace = UIImage.tintedImage(named: "Face - 1\(self.suit.rawValue)", tint: suitColor)!;
				ace.drawAtPoint(CGPoint(
					x: (template.size.width - ace.size.width) / 2.0,
					y: (template.size.height - ace.size.height) / 2.0));
			}
			else
			{
				let faceRank = (self.rank == .Jack ? "J" : self.rank == .Queen ? "Q" : "K");
				
				let face = UIImage(named: "Face - \(faceRank)\(self.suit.rawValue)")!
				face.drawAtPoint(CGPoint(
					x: (template.size.width - face.size.width) / 2.0,
					y: (template.size.height - face.size.height) / 2.0));

				var rankX = template.size.width - 75 - rank.size.width;
				var rankY = 87.5 - (rank.size.height / 2.0);
				suit.drawAtPoint(CGPoint(x: rankX, y: rankY));
			}
			
			let final = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			UIImagePNGRepresentation(final).writeToURL(documentURL, atomically: false);
			documentURL.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey, error: nil);
			
			return final;
		}
	}
}
	