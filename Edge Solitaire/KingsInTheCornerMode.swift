//
//  KingsInTheCornerMode.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 7/5/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

class KingsInTheCornerModeController: GameModeControllerProtocol
{
	func setMarkerImage(cardSpot: CardSpotCell)
	{
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
		let (emptyKingSpot, _) = self.checkKingSpots(cardCollection, checkFn:
			{ (cardOnSpot: Card?) -> Bool in
				return (!cardOnSpot);
			});
		return emptyKingSpot;
	}
	
	func canPlaceCardOnSpot(cardSpot: CardSpotCell, card: Card) -> Bool
	{
		var canPlace = true;
		if card.rank == Card.Rank.King
		{
			canPlace = (cardSpot.index == 0 || cardSpot.index == 3 || cardSpot.index == 12 || cardSpot.index == 15);
		}
		return canPlace;
	}
	
	func canSelectCard(card: Card) -> Bool
	{
		return (card.rank != Card.Rank.King);
	}
	
	func valueOfCard(card: Card) -> Int
	{
		switch card.rank
		{
			case Card.Rank.Ace, Card.Rank.Two, Card.Rank.Three, Card.Rank.Four,
			Card.Rank.Five, Card.Rank.Six, Card.Rank.Seven, Card.Rank.Eight, Card.Rank.Nine:
				return card.rank.toRaw();
			
			case Card.Rank.Ten, Card.Rank.Jack, Card.Rank.Queen:
				return 10;
			
			default:
				return 0;
		}
	}
	
	func gameIsWon(cardCollection: UICollectionView) -> Bool
	{
		let (_, allKingsPlaced) = self.checkKingSpots(cardCollection, checkFn:
			{ (cardOnSpot: Card?) -> Bool in
				return cardOnSpot?.rank == Card.Rank.King;
			});
		
		return allKingsPlaced;
	}
	
	func checkKingSpots(cardCollection: UICollectionView, checkFn: (cardOnSpot:Card?) -> Bool) -> (Bool, Bool)
	{
		var allChecksPassed = false;
		var oneCheckPassed = false;
		
		if cardCollection.numberOfSections() == 1 && cardCollection.numberOfItemsInSection(0) == 16
		{
			allChecksPassed = true;
			let spotsToCheck = [ 0, 3, 12, 15 ];
			
			spotCheckLoop: for i in spotsToCheck
			{
				if let cell = cardCollection.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? CardSpotCell
				{
					let check = checkFn(cardOnSpot: cell.card);
					allChecksPassed = allChecksPassed & check;
					oneCheckPassed = oneCheckPassed | check;
				}
			}
		}
		
		return (oneCheckPassed, allChecksPassed);
	}
}