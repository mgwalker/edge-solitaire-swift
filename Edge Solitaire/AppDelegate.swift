//
//  AppDelegate.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 6/2/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None);
		
		let settings = NSUserDefaults.standardUserDefaults();
		
		// Update settings from Edge Solitaire 2.0 and prior
		if settings.boolForKey("Edge Solitaire: Settings Updated") == false
		{
			let normalPlay = settings.integerForKey("edgeGamesPlayed_normal");
			let normalWin = settings.integerForKey("edgeGamesWon_normal");
			let easyPlay = settings.integerForKey("edgeGamesPlayed_easy");
			let easyWin = settings.integerForKey("edgeGamesWon_easy");

			let keys = (
				easyPlayed: "Edge Solitaire:Games Played:\(GameMode.KingsInTheCorner.rawValue)",
				easyWon: "Edge Solitaire:Games Won:\(GameMode.KingsInTheCorner.rawValue)",
				
				normalPlayed: "Edge Solitaire:Games Played:\(GameMode.FamiliesDivided.rawValue)",
				normalWon: "Edge Solitaire:Games Won:\(GameMode.FamiliesDivided.rawValue))"
			);
			
			settings.setInteger(normalPlay, forKey: keys.normalPlayed);
			settings.setInteger(normalWin, forKey: keys.normalWon);
			settings.setInteger(easyPlay, forKey: keys.easyPlayed);
			settings.setInteger(easyWin, forKey: keys.easyWon);
			
			Settings.muted = settings.boolForKey("muted");
			
			settings.setBool(true, forKey: "Edge Solitaire: Settings Updated");
			
			//settings.removeObjectForKey("edgeGamesPlayed_normal");
			//settings.removeObjectForKey("edgeGamesWon_normal");
			//settings.removeObjectForKey("edgeGamesPlayed_easy");
			//settings.removeObjectForKey("edgeGamesWon_easy");
			//settings.removeObjectForKey("muted");
		}
		
		for card in Card.newDeck()
		{
			card.image;
		}
		
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	// Returns the URL to the application's Documents directory.
	var applicationDocumentsDirectory: NSURL {
	    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
	    return urls[urls.endIndex-1] as! NSURL
	}

}

