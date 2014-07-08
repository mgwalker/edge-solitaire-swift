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
	@IBOutlet var cardCollection:UICollectionView;	// Card collection view
	@IBOutlet var nextCard:UIButton;				// "Next card" button
	
	// Possible board states
	enum BoardState
	{
		case PlacingCards, SummingToTen;
	}
	
	// The deck for the board
	var deck:[Card] = Card.newDeck(shuffle: true);
	
	// Mode controller and current board state
	var gameModeController:GameModeControllerProtocol?;
	var boardState = BoardState.PlacingCards;
	
	// Structure for keeping up with selected cards,
	// keeping a running sum, and clearing the cards
	// when they sum to ten.
	struct CardCellSelectionGroup
	{
		// The list of selected card spots
		static var selectedCardSpots:Array<CardSpotCell> = [ ];
		
		// The sum of the values of all the
		// selected cards.
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
		
		// Add a card to the selection.
		static func addCardSpot(cardSpot:CardSpotCell)
		{
			// Set its selection, add it to the list
			cardSpot.isSelected = true;
			selectedCardSpots += cardSpot;
			
			// If our selection sums to ten, clear
			// the selection.
			if self.selectionSumValue == 10
			{
				self.clearSelection();
			}
		}
		
		static func removeCardSpot(cardSpot:CardSpotCell)
		{
			// Clear the card's selection regardless
			// of whether or not it's currently selected.
			// Just a nice safety feature.
			cardSpot.isSelected = false;
			
			// Now loop over the selection...
			for i in 0..<selectedCardSpots.count
			{
				// ...to find the spot to remove
				if selectedCardSpots[i] == cardSpot
				{
					// Take it out.
					selectedCardSpots.removeAtIndex(i);
					break;
				}
			}
			
			// If our selection sums to ten, clear
			// the selection.
			if self.selectionSumValue == 10
			{
				self.clearSelection();
			}
		}
		
		// Clear the selection.
		static func clearSelection()
		{
			// Clear each card spot in the selection.
			for cardSpot in selectedCardSpots
			{
				cardSpot.clearCard();
			}
			
			// And then empty the list.
			selectedCardSpots = [ ];
		}
	}
	
	func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath:NSIndexPath)
	{
		// Make sure we have a mode controller.
		if !self.gameModeController
		{
			return;
		}
		
		// Make sure we have a cell, and it's a card spot.
		if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CardSpotCell
		{
			// Proceed based on the state of the board.
			switch self.boardState
			{
				case .PlacingCards:
					// Make sure there's not a card on the cell and that the
					// top card on the deck can be placed on the cell.
					if !cell.card && self.gameModeController!.canPlaceCardOnSpot(cell, card: deck[0])
					{
						// Set the card and advance the game.
						cell.card = deck[0];
						self.advanceGame();
					}
				case .SummingToTen:
					// Make sure the cell has a card and it can be selected.
					if cell.card && self.gameModeController!.canSelectCard(cell.card!)
					{
						// If it's already selected, remove it from the
						// selection group...
						if cell.isSelected
						{
							CardCellSelectionGroup.removeCardSpot(cell);
						}
						// ...otherwise, add it to the selection group.
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
		// How we proceed depends on the board state
		switch self.boardState
		{
			// If we're placing cards...
			case .PlacingCards:
				// Remove the card off the top of the deck.  It's
				// now on the board.  And update the next card
				// button to the next card.
				deck.removeAtIndex(0);
				self.nextCard.setBackgroundImage(CardHelper.imageForCard(deck[0]), forState: UIControlState.Normal);

				// Check if the player already won.  If they did, then,
				// you know, stop here.
				if self.gameModeController?.gameIsWon(self.cardCollection) == true
				{
					print("Game over - you won!\n");
				}

				// Assume all the card spots are covered...
				var allSpotsCovered = true;
				cellLoop: for i in 0..<16
				{
					var indexPath = NSIndexPath(forRow: i, inSection: 0);
					if let cell = self.cardCollection.cellForItemAtIndexPath(indexPath) as? CardSpotCell
					{
						// If any cell is lacking a card, then we know all
						// spots are not yet covered and we can bail out.
						if !cell.card
						{
							allSpotsCovered = false;
							break cellLoop;
						}
					}
				}
				
				// If all the spots are covered...
				if allSpotsCovered
				{
					// ...switch to summing mode and set the next card button
					// to the card back image.
					self.boardState = BoardState.SummingToTen;
					self.nextCard.setBackgroundImage(UIImage(named: "Back - Red"), forState: UIControlState.Normal);
				}
				else
				{
					// ...otherwise, check if the next card can be played.  If
					// it can't, then game over, sucka.
					if self.gameModeController?.canPlaceCardAnywhere(self.cardCollection, card: deck[0]) == false
					{
						print("Game over - can't place next card\n");
					}
				}
			
			// There's not really an advancement if we're in
			// summing mode, and if there end up being other
			// modes, we'll just happily do nothing until
			// we figure out what should happen in that mode.
			default:
				break;
		}
	}
	
	// Action for the next card button
	@IBAction func resumePlacingCards()
	{
		// Make sure we're in summing mode
		if self.boardState == BoardState.SummingToTen
		{
			// Change the board state to "placing"
			self.boardState = BoardState.PlacingCards;
			
			// Set the next card button image to the first card on the deck
			self.nextCard.setBackgroundImage(CardHelper.imageForCard(deck[0]), forState: UIControlState.Normal);
			
			// And if we have a mode controller, make sure we can place this
			// card somewhere.  If we can't, the game is over.
			if self.gameModeController?.canPlaceCardAnywhere(self.cardCollection, card: deck[0]) == false
			{
				print("Game over - can't place next card\n");
			}
		}
	}
}