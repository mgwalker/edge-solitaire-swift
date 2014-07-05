//
//  Card.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 6/10/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import Foundation

class Card
{
	enum Suit:Character
	{
		case Club = "♣", Diamond = "♦", Heart = "♥", Spade = "♠";
		
		static func all() -> Suit[]
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
		
		static func all() -> Rank[]
		{
			return [
				Rank.Ace, Rank.Two, Rank.Three, Rank.Four,
				Rank.Five, Rank.Six, Rank.Seven, Rank.Eight,
				Rank.Nine, Rank.Ten, Rank.Jack, Rank.Queen,
				Rank.King
			];
		}
	}
	
	let suit:Suit;
	let rank:Rank;
	
	init(suit:Suit, rank:Rank)
	{
		self.suit = suit;
		self.rank = rank;
	}
	
	class func newDeck() -> Card[]
	{
		var cards:Card[] = Card[]();
		for suit in Suit.all()
		{
			for rank in Rank.all()
			{
				cards += Card(suit:suit, rank:rank);
			}
		}
		
		for i in 0..cards.count
		{
			let swap = Int(arc4random()) % (52 - i);
			var temp = cards[51 - i];
			cards[51 - i] = cards[swap];
			cards[swap] = temp;
		}
		
		return cards;
	}
}
