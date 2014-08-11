//
//  RoyalsOnEdgeMode.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 8/10/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

class RoyalsOnEdgeModeController : GameModeControllerProtocol
{
	func checkEdgeSpots(cardCollection:UICollectionView, checkFn: (cardOnSpot:Card?) -> Bool) -> (Bool, Bool)
	{
		var allChecksPassed = false;
		var oneCheckPassed = false;
		
		// Make sure  the collection view being tested has a
		// section that contains 16 cells.  That's required
		// of the game board, so, y'know...
		if cardCollection.numberOfSections() == 1 && cardCollection.numberOfItemsInSection(0) == 16
		{
			// Assume that all checks will pass.  If any fail,
			// then we fan flip this to false.
			allChecksPassed = true;
			
			// We're only interested in checking edge spots.
			let spotsToCheck = [ 0, 1, 2, 3, 4, 7, 8, 11, 12, 13, 14, 15 ];
			
			// Now loop through those.
			spotCheckLoop: for i in spotsToCheck
			{
				// Make sure we have a card spot at this cell index.
				if let cell = cardCollection.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? CardSpotCell
				{
					// Call the check function that was passed in
					// on the card on this spot, if any.
					let check = checkFn(cardOnSpot: cell.card);
					
					// Update the all/one flags accordingly.
					allChecksPassed = allChecksPassed & check;
					oneCheckPassed = oneCheckPassed | check;
				}
			}
		}
		
		// Return 'em.
		return (oneCheckPassed, allChecksPassed);
	}
	
	func isFaceCard(card:Card) -> Bool
	{
		return (card.rank == Card.Rank.King || card.rank == Card.Rank.Queen || card.rank == Card.Rank.Jack);
	}
	
	// Sets the marker image on a card spot cell.
	func setMarkerImage(cardSpot:CardSpotCell)
	{
		switch cardSpot.index
		{
			case 5, 6, 9, 10:
				break;
			
			default:
				cardSpot.markerImage.image = UIImage(named: "Marker - King");
				break;
		}
	}
	
	// Indicates that a given card may be placed somewhere on
	// the board, given the current card cell collection.
	func canPlaceCardAnywhere(cardCollection:UICollectionView, card:Card) -> Bool
	{
		var canPlace = true;
		if isFaceCard(card)
		{
			let (oneEmpty, _) = checkEdgeSpots(cardCollection, checkFn: {
				(cardOnSpot:Card?) -> Bool in
				return (cardOnSpot == nil);
			})
			
			canPlace = oneEmpty;
		}
		
		return canPlace;
	}
	
	// Indicates whether a card may be placed on a particular
	// card spot.
	func canPlaceCardOnSpot(cardSpot:CardSpotCell, card:Card) -> Bool
	{
		var canPlace = true;
		if isFaceCard(card)
		{
			if cardSpot.index == 5 || cardSpot.index == 6 || cardSpot.index == 9 || cardSpot.index == 10
			{
				canPlace = false;
			}
		}
		return canPlace;
	}
	
	// Indicates whether a card may be selected.
	func canSelectCard(card:Card) -> Bool
	{
		return !isFaceCard(card);
	}
	
	// Determines whether or not any cards may be cleared from
	// the particular board.
	func canClearCardsFromBoard(cardCollection:UICollectionView) -> Bool
	{
		var cardValues = [Int]();
		
		// Make sure  the collection view being tested has a
		// section that contains 16 cells.  That's required
		// of the game board, so, y'know...
		if cardCollection.numberOfSections() == 1 && cardCollection.numberOfItemsInSection(0) == 16
		{
			// Now loop through those.
			for i in 1..<16
			{
				// Make sure we have a card spot at this cell index.
				if let cell = cardCollection.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? CardSpotCell
				{
					if let card = cell.card
					{
						switch card.rank
						{
							case .King, .Queen, .Jack:
								break;
							
							default:
								cardValues += [ card.rank.toRaw() ];
						}
					}
				}
			}
		}
		
		return SumToTenChecker.hasSumToTen(cardValues);
	}
	
	// Determines whether a particular selection of cards can
	// be removed.
	func canClearSelectedCards(cards:[Card]) -> Bool
	{
		var sum = 0;
		for card in cards
		{
			switch card.rank
				{
			case .Ten, .Jack, .Queen:
				sum += 10;
			default:
				sum += card.rank.toRaw();
			}
		}
		
		return (sum == 10);
	}
	
	// Indicates whether the game is won based on a given
	// card cell collection.
	func gameIsWon(cardCollection:UICollectionView) -> Bool
	{
		// The game is over if the king spots have king cards.  We need
		// all the spots to check out, so ignore the one-test-passed
		// value and only keep the all-tests-passed value.
		let (_, allRoyalsPlaced) = checkEdgeSpots(cardCollection, checkFn: {
			(cardOnSpot: Card?) -> Bool in
			if cardOnSpot != nil
			{
				return self.isFaceCard(cardOnSpot!);
			}
			return false;
		});
		
		return allRoyalsPlaced;
	}
}
