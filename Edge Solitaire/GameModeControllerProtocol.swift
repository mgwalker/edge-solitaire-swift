//
//  GameModeProtocol.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 6/10/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import Foundation
import UIKit

// Game modes
enum GameMode:String
{
	case KingsInTheCorner = "KINGS IN THE CORNER", RoyalsOnEdge = "ROYALS ON EDGE", FamiliesDivided = "FAMILIES DIVIDED";
}

protocol GameModeControllerProtocol
{
	// Sets the marker image on a card spot cell.
	func setMarkerImage(cardSpot:CardSpotCell);

	// Indicates that a given card may be placed somewhere on
	// the board, given the current card cell collection.
	func canPlaceCardAnywhere(cardCollection:UICollectionView, card:Card) -> Bool;
	
	// Indicates whether a card may be placed on a particular
	// card spot.
	func canPlaceCardOnSpot(cardSpot:CardSpotCell, card:Card) -> Bool;
	
	// Indicates whether a card may be selected.
	func canSelectCard(card:Card) -> Bool;
	
	// Indicates the summation value of a card.
	func valueOfCard(card:Card) -> Int;
	
	// Indicates whether the game is won based on a given
	// card cell collection.
	func gameIsWon(cardCollection:UICollectionView) -> Bool;
}

// Gets made mode controllers
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

