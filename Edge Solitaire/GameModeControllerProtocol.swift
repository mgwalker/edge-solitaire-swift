//
//  GameModeProtocol.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 6/10/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import Foundation
import UIKit

enum GameMode:String
{
	case KingsInTheCorner = "KINGS IN THE CORNER", RoyalsOnEdge = "ROYALS ON EDGE", FamiliesDivided = "FAMILIES DIVIDED";
}

protocol GameModeControllerProtocol
{
	func setMarkerImage(cardSpot:CardSpotCell);

	func canPlaceCardAnywhere(cardCollection:UICollectionView, card:Card) -> Bool;
	func canPlaceCardOnSpot(cardSpot:CardSpotCell, card:Card) -> Bool;
	
	func canSelectCard(card:Card) -> Bool;
	func valueOfCard(card:Card) -> Int;
	
	func gameIsWon(cardCollection:UICollectionView) -> Bool;
}

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

