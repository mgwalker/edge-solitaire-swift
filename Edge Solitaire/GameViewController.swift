//
//  GameViewController.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 6/10/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

class GameViewController:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate
{
	@IBOutlet var cardCollection:UICollectionView;
	@IBOutlet var nextCard:UIButton;
	
	enum BoardState
	{
		case PlacingCards, SummingToTen;
	}
	
	var deck:[Card] = [];
	
	var gameModeController:GameModeControllerProtocol?;
	var boardState = BoardState.PlacingCards;
	
	struct CardCellSelectionGroup
	{
		static var selectedCardSpots:Array<CardSpotCell> = [ ];
		static var selectionSumValue:Int
		{
			get
			{
				var sum:Int = 0;
				for cardSpot in selectedCardSpots
				{
					sum += cardSpot.value;
				}
				return sum;
			}
		}
		
		static func addCardSpot(cardSpot:CardSpotCell)
		{
			cardSpot.isSelected = true;
			selectedCardSpots += cardSpot;
			if self.selectionSumValue == 10
			{
				self.clearSelection();
			}
		}
		
		static func removeCardSpot(cardSpot:CardSpotCell)
		{
			cardSpot.isSelected = false;
			for i in 0..<selectedCardSpots.count
			{
				if selectedCardSpots[i] == cardSpot
				{
					selectedCardSpots.removeAtIndex(i);
					break;
				}
			}
			if self.selectionSumValue == 10
			{
				self.clearSelection();
			}
		}
		
		static func clearSelection()
		{
			for cardSpot in selectedCardSpots
			{
				cardSpot.clearCard();
			}
			selectedCardSpots = [ ];
		}
	}
		
	func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath:NSIndexPath)
	{
		let collectionViewCell = collectionView.cellForItemAtIndexPath(indexPath);
		if !self.gameModeController
		{
			return;
		}
		
		if let cell = collectionViewCell as? CardSpotCell
		{
			switch self.boardState
			{
				case .PlacingCards:
					if !cell.card && self.gameModeController!.canPlaceCardOnSpot(cell, card: deck[0])
					{
						cell.card = deck[0];
						self.advanceGame();
					}
				case .SummingToTen:
					if cell.card && self.gameModeController!.canSelectCard(cell.card!)
					{
						if cell.isSelected
						{
							CardCellSelectionGroup.removeCardSpot(cell);
						}
						else
						{
							CardCellSelectionGroup.addCardSpot(cell);
						}
					}
					break;
			}
		}
	}
	
	func advanceGame()
	{
		switch self.boardState
		{
			case .PlacingCards:
				
				if self.gameModeController?.gameIsWon(self.cardCollection) == true
				{
					print("Game over - you won!\n");
				}
				
				deck.removeAtIndex(0);
				var allSpotsCovered = true;
				
				cellLoop: for i in 0..<16
				{
					var indexPath = NSIndexPath(forRow: i, inSection: 0);
					if let cell = self.cardCollection.cellForItemAtIndexPath(indexPath) as? CardSpotCell
					{
						if !cell.card
						{
							allSpotsCovered = false;
							break cellLoop;
						}
					}
				}
				
				if allSpotsCovered
				{
					self.boardState = BoardState.SummingToTen;
					self.nextCard.setBackgroundImage(UIImage(named: "Back - Red"), forState: UIControlState.Normal);
				}
				else
				{
					self.nextCard.setBackgroundImage(CardHelper.imageForCard(deck[0]), forState: UIControlState.Normal);
					var canPlace = self.gameModeController?.canPlaceCardAnywhere(self.cardCollection, card: deck[0]);
					if self.gameModeController?.canPlaceCardAnywhere(self.cardCollection, card: deck[0]) == false
					{
						print("Game over - can't place next card\n");
					}
				}
			
			case .SummingToTen:
				break;
		}
	}
	
	@IBAction func resumePlacingCards()
	{
		if self.boardState == BoardState.SummingToTen
		{
			self.boardState = BoardState.PlacingCards;
			
			self.nextCard.setBackgroundImage(CardHelper.imageForCard(deck[0]), forState: UIControlState.Normal);
			if self.gameModeController?.canPlaceCardAnywhere(self.cardCollection, card: deck[0]) == false
			{
				print("Game over - can't place next card\n");
			}
		}
	}
}