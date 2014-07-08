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
	class func newDeck(shuffle shuffled:Bool = true) -> [Card]
	{
		var cards:[Card] = [Card]();
		for suit in Suit.all()
		{
			for rank in Rank.all()
			{
				cards += Card(suit:suit, rank:rank);
			}
		}
		
		if shuffled
		{
			Card.shuffle(cards);
		}

		return cards;
	}
	
	// Shuffle method.  Implementes Fisher-Yates algorithm.
	class func shuffle(var cards:[Card])
	{
		for i in 0..<cards.count
		{
			let swap = Int(arc4random_uniform(52 - UInt32(i)));
			var temp = cards[51 - i];
			cards[51 - i] = cards[swap];
			cards[swap] = temp;
		}
	}
}
