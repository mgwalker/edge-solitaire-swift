//
//  Settings.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 9/21/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import Foundation

class Settings
{
	private class func keysForMode(mode: GameMode) -> (played: String, won: String)
	{
		return (
			"Edge Solitaire:Games Played:\(mode.toRaw())",
			"Edge Solitaire:Games Won:\(mode.toRaw())"
		);
	}
	
	class func gameStatsForMode(mode: GameMode) -> (played: Int, won: Int, percent: Float)
	{
		let keys = Settings.keysForMode(mode);
		let played = NSUserDefaults.standardUserDefaults().integerForKey(keys.played);
		let won = NSUserDefaults.standardUserDefaults().integerForKey(keys.won);
		
		let percent = (played == 0 ? 0.0 : Float(won) / Float(played)) * 100;
		
		return (played, won, percent);
	}
	
	class func incrementGameCountForMode(mode: GameMode, didWin: Bool = false)
	{
		let settings = NSUserDefaults.standardUserDefaults();
		
		let keys = Settings.keysForMode(mode);
		let played = settings.integerForKey(keys.played) + 1;
		settings.setInteger(played, forKey: keys.played);
		
		if didWin
		{
			let won = settings.integerForKey(keys.won) + 1;
			settings.setInteger(won, forKey: keys.won);
		}
		
		settings.synchronize();
	}
	
	class var totalGamesWon:Int
	{
		get
		{
			var gamesWon = 0;
			
			gamesWon += Settings.gameStatsForMode(.KingsInTheCorner).won;
			gamesWon += Settings.gameStatsForMode(.RoyalsOnEdge).won;
			gamesWon += Settings.gameStatsForMode(.FamiliesDivided).won;
			
			return gamesWon;
		}
	}
	
	class var muted:Bool
	{
		get
		{
			return NSUserDefaults.standardUserDefaults().boolForKey("Edge Solitaire:Muted");
		}
		set (muted)
		{
			NSUserDefaults.standardUserDefaults().setBool(muted, forKey: "Edge Solitaire:Muted");
			NSUserDefaults.standardUserDefaults().synchronize();
		}
	}
}