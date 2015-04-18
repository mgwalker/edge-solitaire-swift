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
	@IBOutlet var cardCollection:UICollectionView!;	// Card collection view
	@IBOutlet var nextCard:UIButton!;				// "Next card" button
	@IBOutlet var gameStat:UIBarItem!;
	@IBOutlet var instruction:UILabel!;
	
	// Possible board states
	enum BoardState
	{
		case PlacingCards, ClearingCards;
	}
	
	// The deck for the board
	var deck:[Card] = [ ];
	
	// Mode controller and current board state
	var gameModeController:GameModeControllerProtocol!;
	var boardState = BoardState.PlacingCards;
	
	func showGameStats()
	{
		let stat = Settings.gameStatsForMode(self.gameModeController.mode);
		
		let formatter = NSNumberFormatter();
		formatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4;
		formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle;

		let played = formatter.stringFromNumber(NSNumber(integer: stat.played))!;
		let won = formatter.stringFromNumber(NSNumber(integer: stat.won))!;

		var statString = "";
		
		var size = self.traitCollection.horizontalSizeClass;
		switch(size)
		{
			case .Compact:
				statString = "Won \(won) of \(played)";
				break;
			default:
				statString = "Won \(won) of \(played)";
				break;
		}
		
		self.gameStat.title = statString;
	}
	
	// Structure for keeping up with selected cards
	// and clearing the cards when the controller
	// says we should.
	struct CardCellSelectionGroup
	{
		// The list of selected card spots
		static var selectedCardSpots:Array<CardSpotCell> = [ ];

		static var selectedCards:[Card]
		{
			get
			{
				var cards = [Card]();
				for spot in selectedCardSpots
				{
					if spot.card != nil
					{
						cards += [spot.card!]
					}
				}
				return cards;
			}
		}
		
		// Add a card to the selection.
		static func addCardSpot(cardSpot:CardSpotCell)
		{
			// Set its selection, add it to the list
			cardSpot.isCellSelected = true;
			selectedCardSpots += [ cardSpot ];
		}
		
		static func removeCardSpot(cardSpot:CardSpotCell)
		{
			// Clear the card's selection regardless
			// of whether or not it's currently selected.
			// Just a nice safety feature.
			cardSpot.isCellSelected = false;

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
		}
		
		static func removeAllCardSpots()
		{
			for i in 0..<selectedCardSpots.count
			{
				selectedCardSpots[i].isCellSelected = false;
			}
			selectedCardSpots = [ ];
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
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
	{
		// Make sure we have a mode controller.
		if self.gameModeController == nil
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
					let (canPlace, reason) = self.gameModeController.canPlaceCardOnSpot(cell, card:  deck[0]);
					if cell.card == nil && canPlace
					{
						// Set the card and advance the game.
						cell.card = deck[0];
						self.advanceGame();
					}
					else if !canPlace
					{
						self.instruction.text = reason;
					}
				case .ClearingCards:
					// Make sure the cell has a card and it can be selected.
					if cell.card != nil
					{
						let (canSelect, reason) = self.gameModeController.canSelectCard(cell.card!);
						if canSelect
						{
							self.instruction.text = self.gameModeController.clearingInstruction;
							
							// If it's already selected, remove it from the
							// selection group...
							if cell.isCellSelected
							{
								CardCellSelectionGroup.removeCardSpot(cell);
								if self.gameModeController.canClearSelectedCards(CardCellSelectionGroup.selectedCards)
								{
									CardCellSelectionGroup.clearSelection();
								}
							}
							// ...otherwise, add it to the selection group.
							else
							{
								CardCellSelectionGroup.addCardSpot(cell);
								if self.gameModeController.canClearSelectedCards(CardCellSelectionGroup.selectedCards)
								{
									CardCellSelectionGroup.clearSelection();
								}
							}
						}
						else
						{
							self.instruction.text = reason;
						}
					}
					break;
			}
		}
	}
	
	func advanceGame()
	{
		self.setInstructionText();
		
		// How we proceed depends on the board state
		switch self.boardState
		{
			// If we're placing cards...
			case .PlacingCards:
				// Remove the card off the top of the deck.  It's
				// now on the board.  And update the next card
				// button to the next card.
				if deck.count > 0
				{
					deck.removeAtIndex(0);
					if deck.count > 0
					{
						self.nextCard.setBackgroundImage(deck[0].image, forState: UIControlState.Normal);
					}
					else
					{
						self.nextCard.setBackgroundImage(nil, forState: UIControlState.Normal);
					}
				}

				// Check if the player already won.  If they did, then,
				// you know, stop here.
				if self.gameModeController.gameIsWon(self.cardCollection) == true
				{
					Settings.incrementGameCountForMode(self.gameModeController.mode, didWin: true);
					self.showGameStats();
					let popup = PopupView.showPopup(type: PopupView.PopupType.Win, onView: self.view);
					popup.restartGameCallback = self.startNewGame;
					popup.quitGameCallback = self.quitToMenu;
					return;
				}

				// Assume all the card spots are covered...
				var allSpotsCovered = true;
				iterateOverCardSpots({
					(cardSpot:CardSpotCell) -> Bool in
					if cardSpot.card == nil
					{
						allSpotsCovered = false;
						return false;
					}
					return true;
				});
				
				// If all the spots are covered...
				if allSpotsCovered
				{
					// ...and some combination of cards can be cleared...
					if self.gameModeController.canClearCardsFromBoard(self.cardCollection)
					{
						// ...switch to summing mode and set the next card button
						// to the card back image.
						self.boardState = BoardState.ClearingCards;
						self.setInstructionText();
						self.nextCard.setBackgroundImage(UIImage(named: "Back - Red"), forState: UIControlState.Normal);
					}
					else
					{
						// ...or else all spots are covered but nothing can be removed,
						// so the game is over.  Alas.
						Settings.incrementGameCountForMode(self.gameModeController.mode);
						self.showGameStats();
						let popup = PopupView.showPopup(type: PopupView.PopupType.CannotRemove, onView: self.view);
						popup.restartGameCallback = self.startNewGame;
						popup.quitGameCallback = self.quitToMenu;
					}
				}
				else
				{
					// ...otherwise, check if the next card can be played.  If
					// it can't, then game over, sucka.
					if self.gameModeController.canPlaceCardAnywhere(self.cardCollection, card: deck[0]) == false
					{
						Settings.incrementGameCountForMode(self.gameModeController.mode);
						self.showGameStats();
						let popup = PopupView.showPopup(type: PopupView.PopupType.CannotPlace, onView: self.view);
						popup.restartGameCallback = self.startNewGame;
						popup.quitGameCallback = self.quitToMenu;
					}
				}
			
			// There's not really an advancement if we're in
			// clearing mode, and if there end up being other
			// modes, we'll just happily do nothing until
			// we figure out what should happen in that mode.
			default:
				break;
		}
	}
	
	func setInstructionText()
	{
		switch self.boardState
		{
			case .PlacingCards:
				self.instruction.text = "Tap a spot above to place the next card.";
				break;
			
			case .ClearingCards:
				self.instruction.text = self.gameModeController.clearingInstruction;
				break;
		}
	}
	
	// Action for the next card button
	@IBAction func resumePlacingCards()
	{
		// Make sure we're in clearing mode
		if self.boardState == BoardState.ClearingCards
		{
			// Also make sure that there's at least one clear spot.  If
			// there's not, this touch was probably an accident.
			iterateOverCardSpots({
				(cardSpot:CardSpotCell) -> Bool in
				
				if cardSpot.card == nil
				{
					// Change the board state to "placing"
					self.boardState = BoardState.PlacingCards;
					CardCellSelectionGroup.removeAllCardSpots();
					
					// Set the next card button image to the first card on the deck
					self.nextCard.setBackgroundImage(self.deck[0].image, forState: UIControlState.Normal);
					
					// And if we have a mode controller, make sure we can place this
					// card somewhere.  If we can't, the game is over.
					if self.gameModeController.canPlaceCardAnywhere(self.cardCollection, card: self.deck[0]) == false
					{
						Settings.incrementGameCountForMode(self.gameModeController.mode);
						self.showGameStats();
						let popup = PopupView.showPopup(type: PopupView.PopupType.CannotPlace, onView: self.view);
						popup.restartGameCallback = self.startNewGame;
						popup.quitGameCallback = self.quitToMenu;
					}

					return false;
				}
				
				return true;
			});
		}
	}
	
	@IBAction func showQuitOrRestartMenu()
	{
		let popup = PopupView.showPopup(type: PopupView.PopupType.Restart, onView: self.view);
		popup.restartGameCallback = self.startNewGame;
		popup.quitGameCallback = self.quitToMenu;
	}
	
	func startNewGame(popup: PopupView?)
	{
		let stats = Settings.gameStatsForMode(self.gameModeController.mode);
		
		popup?.close();
		
		self.deck = Card.newDeck(shuffle: true);
		self.boardState = BoardState.PlacingCards;
		self.setInstructionText();
		
		self.nextCard.setBackgroundImage(deck[0].image, forState: UIControlState.Normal);
		
		iterateOverCardSpots({
			(cardSpot:CardSpotCell)->Bool in
			cardSpot.clearCard();
			return true;
		});
	}
	
	func iterateOverCardSpots(fn:(cardSpot:CardSpotCell)->Bool)
	{
		if self.cardCollection.numberOfSections() == 1 && self.cardCollection.numberOfItemsInSection(0) == 16
		{
			for item in 0..<16
			{
				if let cardSpot = self.cardCollection.cellForItemAtIndexPath(NSIndexPath(forRow: item, inSection: 0)) as? CardSpotCell
				{
					if fn(cardSpot: cardSpot) == false
					{
						break;
					}
				}
			}
		}
		
	}
	
	func quitToMenu(popup: PopupView?)
	{
		popup?.close();
		self.navigationController?.popToRootViewControllerAnimated(true);
	}
}