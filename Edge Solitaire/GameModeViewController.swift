//
//  GameModeViewController.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 6/3/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

// Game mode picker
class GameModeViewController:UITableViewController
{
	// Description text and cell for the different game modes.
	@IBOutlet var kingsInTheCornerDescription:UILabel!;
	@IBOutlet var kingsInTheCornerStats:UILabel!;
	@IBOutlet var kingsInTheCornerCell:UITableViewCell!;
	@IBOutlet var kingsInTheCornerImage:UIImageView!;
	
	@IBOutlet var royalsOnEdgeDescription:UILabel!;
	@IBOutlet var royalsOnEdgeStats:UILabel!;
	@IBOutlet var royalsOnEdgeCell:UITableViewCell!;
	@IBOutlet var royalsOnEdgeImage:UIImageView!;
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		self.setBackground();
	}
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated);
		
		// Set the size of the description text based on our
		// size class.  Narrow devices will need smaller fonts,
		// wide devices have lots of dead space.  Fill it up.
		let size = self.traitCollection.horizontalSizeClass;
		switch size
		{
			case UIUserInterfaceSizeClass.Compact:
				kingsInTheCornerDescription.font = kingsInTheCornerDescription.font.fontWithSize(16);
			default:
				kingsInTheCornerDescription.font = kingsInTheCornerDescription.font.fontWithSize(24);
		}
		royalsOnEdgeDescription.font = kingsInTheCornerDescription.font;
		
		let formatter = NSNumberFormatter();
		formatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4;
		formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle;
		
		//let suits = [ "♣", "♦", "♥", "♠" ];
		let suit = [ "♣", "♦", "♥", "♠" ][Int(arc4random_uniform(4))];

		let kingsInTheCornerStats = Settings.gameStatsForMode(GameMode.KingsInTheCorner);
		let kPlay = formatter.stringFromNumber(NSNumber(integer: kingsInTheCornerStats.played))!;
		let kWon = formatter.stringFromNumber(NSNumber(integer: kingsInTheCornerStats.won))!;
		let kPct = NSString(format: "%.1f", kingsInTheCornerStats.percent);
		kingsInTheCornerImage.image = UIImage(named: "Face - K" + suit);
		
		let royalsOnEdgeStats = Settings.gameStatsForMode(GameMode.RoyalsOnEdge);
		let rPlay = formatter.stringFromNumber(NSNumber(integer: royalsOnEdgeStats.played))!;
		let rWon = formatter.stringFromNumber(NSNumber(integer: royalsOnEdgeStats.won))!;
		let rPct = NSString(format: "%.1f", royalsOnEdgeStats.percent);
		royalsOnEdgeImage.image = UIImage(named: "Face - Q" + suit);
		
		let familesDividedStats = Settings.gameStatsForMode(GameMode.FamiliesDivided);
		let fPlay = formatter.stringFromNumber(NSNumber(integer: familesDividedStats.played))!;
		let fWon = formatter.stringFromNumber(NSNumber(integer: familesDividedStats.won))!;
		let fPct = NSString(format: "%.1f", familesDividedStats.percent);
		
		self.kingsInTheCornerStats.text = "Won \(kWon) of \(kPlay) (\(kPct)%)";
		self.royalsOnEdgeStats.text = "Won \(rWon) of \(rPlay) (\(rPct)%)";
	}
	
	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
	{
		// iPad hack.  For some reason, the background color for
		// table cells and headers as defined in NIB/Storyboard
		// are not honored on iPad.  The workaround is to set
		// the colors in code, which sucks but is better than
		// letting the colors be wrong.
		if indexPath.section == 0
		{
			cell.backgroundColor = UIColor.blackColor();
		}
		else if(indexPath.section > 0 && indexPath.row == 0)
		{
			cell.backgroundColor = UIColor.clearColor();
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		// Clear the table cell selection.  Animating this causes
		// the nice gentle flash when the user taps the row.
		tableView.deselectRowAtIndexPath(indexPath, animated: true);
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
	{
		// Make sure the segue is coming from a table cell...
		if let cell = sender as? UITableViewCell
		{
			// Make sure the cell refers to a game mode...
			if let mode = GameMode(rawValue: cell.reuseIdentifier!.uppercaseString)
			{
				// Make sure there's a controller for the mode...
				if let modeController = GameModeFactory.GetGameMode(mode)
				{
					// Make sure the incoming view is the game board...
					if let vc = segue.destinationViewController as? GameViewController
					{
						// And set the mode controller on the game board!
						vc.gameModeController = modeController;
					}
				}
			}
		}
	}
}