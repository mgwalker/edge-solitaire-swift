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
	
	private class SoundDelegate : NSObject, AVAudioPlayerDelegate {
		@objc func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
			player.prepareToPlay();
		}
	}
	
	public static func initialize() {
		do {
			try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient);

			_cardPlacedSound = try AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("Sounds/Place", withExtension: ".mp3")!);
			_cardPlacedSound?.prepareToPlay();
			//_cardPlacedSound?.delegate = SoundDelegate();

			_cardsClearedSound = try AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("Sounds/Clear", withExtension: ".mp3")!);
			_cardsClearedSound?.prepareToPlay();
			//_cardsClearedSound?.delegate = SoundDelegate();

			_gameLostSound = try AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("Sounds/GameOver", withExtension: ".mp3")!);
			_gameLostSound?.prepareToPlay();
			//_gameLostSound?.delegate = SoundDelegate();

			_gameWonSound = try AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("Sounds/Win", withExtension: ".mp3")!);
			_gameWonSound?.prepareToPlay();
			//_gameWonSound?.delegate = SoundDelegate();
		} catch { }
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
			//if !player.playing {
				player.play();
			//}
			//if player.playing {
			//	player.stop();
			//}
			//player.play();
		}
	}
}