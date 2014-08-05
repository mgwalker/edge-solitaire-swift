//
//  KingsInTheCornerMode.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 7/5/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

// Mode controller for Kings in the Corner
class KingsInTheCornerModeController: GameModeControllerProtocol
{
	// Runs tests on the four kings spots, using a check defined
	// by the caller.  Indicates if any tests passed and whether
	// all tests passed.
	func checkKingSpots(cardCollection: UICollectionView, checkFn: (cardOnSpot:Card?) -> Bool) -> (Bool, Bool)
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
			
			// We're only interested in checking spots 0, 3, 12,
			// and 15, which correspond to the corners.
			let spotsToCheck = [ 0, 3, 12, 15 ];
			
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

	func setMarkerImage(cardSpot: CardSpotCell)
	{
		// There's only a marker on the corners, so we only care
		// about spots with indexes of 0, 3, 12, or 15.
		switch cardSpot.index
		{
			case 0, 3, 12, 15:
				cardSpot.markerImage.image = UIImage(named: "Marker - King");
			default:
				break;
		}
	}
	
	func canPlaceCardAnywhere(cardCollection: UICollectionView, card: Card) -> Bool
	{
		// If the card is a king...
		if card.rank == Card.Rank.King
		{
			// ...then check if any of the king spots are empty.  We're only
			// interested in the one-check-passed return so throw away the
			// all-checks-passed value (since we don't care).
			let (emptyKingSpot, _) = self.checkKingSpots(cardCollection, checkFn:
				{
					(cardOnSpot: Card?) -> Bool in
					return (cardOnSpot == nil);
				});
			return emptyKingSpot;
		}
		
		// Otherwise, the answer is yes because we don't care.
		return true;
	}
	
	func canPlaceCardOnSpot(cardSpot: CardSpotCell, card: Card) -> Bool
	{
		// If the card is a king...
		if card.rank == Card.Rank.King
		{
			// ...then make sure the spot is a corner.
			return (cardSpot.index == 0 || cardSpot.index == 3 || cardSpot.index == 12 || cardSpot.index == 15);
		}
		
		// Otherwise, the answer is yes because we (still) don't care.
		return true;
	}
	
	func canSelectCard(card: Card) -> Bool
	{
		// Kings can't be selected because they can't
		// be removed.  Easy enough.
		return (card.rank != Card.Rank.King);
	}
	
	func valueOfCard(card: Card) -> Int
	{
		switch card.rank
		{
			case Card.Rank.Ace, Card.Rank.Two, Card.Rank.Three, Card.Rank.Four,
			Card.Rank.Five, Card.Rank.Six, Card.Rank.Seven, Card.Rank.Eight, Card.Rank.Nine:
				return card.rank.toRaw();

			// Jacks and queens are worth 10 in this mode.
			case Card.Rank.Ten, Card.Rank.Jack, Card.Rank.Queen:
				return 10;
			
			default:
				return 0;
		}
	}
	
	func gameIsWon(cardCollection: UICollectionView) -> Bool
	{
		// The game is over if the king spots have king cards.  We need
		// all the spots to check out, so ignore the one-test-passed
		// value and only keep the all-tests-passed value.
		let (_, allKingsPlaced) = self.checkKingSpots(cardCollection, checkFn:
			{ (cardOnSpot: Card?) -> Bool in
				return cardOnSpot?.rank == Card.Rank.King;
			});
		
		return allKingsPlaced;
	}
}