//
//  Sounds.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 4/22/15.
//  Copyright (c) 2015 Greg Walker. All rights reserved.
//

import Foundation
import AVFoundation

public class Sounds {

	private static var _cardPlacedSound : AVAudioPlayer?;
	private static var _cardsClearedSound : AVAudioPlayer?;
	private static var _gameLostSound : AVAudioPlayer?;
	private static var _gameWonSound : AVAudioPlayer?;
	
	public enum SoundType:Int {
		case CardPlaced, CardsCleared, GameLost, GameWon
	}
	
	public static func initialize() {
		AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, error: nil);

		_cardPlacedSound = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("Sounds/Place", withExtension: ".mp3"), error: nil);
		_cardsClearedSound = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("Sounds/Clear", withExtension: ".mp3"), error: nil);
		_gameLostSound = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("Sounds/GameOver", withExtension: ".mp3"), error: nil);
		_gameWonSound = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("Sounds/Win", withExtension: ".mp3"), error: nil);
		
		Sounds._cardPlacedSound!.prepareToPlay();
		Sounds._cardsClearedSound!.prepareToPlay();
		Sounds._gameLostSound!.prepareToPlay();
		Sounds._gameWonSound!.prepareToPlay();
	}
	
	public static func play(sound:SoundType) {
		if !Settings.muted {
			
			var player : AVAudioPlayer;
			
			switch sound {
				case .CardPlaced:
					player = _cardPlacedSound!;
					break;
				
				case .CardsCleared:
					player = _cardsClearedSound!;
					break;
				
				case .GameLost:
					player = _gameLostSound!;
					break;

				case .GameWon:
					player = _gameWonSound!;
					break;
			}
			
			player.currentTime = 0;
			if player.playing {
				player.stop();
			}
			player.play();
		}
	}
}