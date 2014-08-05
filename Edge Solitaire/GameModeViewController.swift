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
	@IBOutlet var kingsInTheCornerCell:UITableViewCell!;
	
	@IBOutlet var royalsOnEdgeDescription:UILabel!;
	@IBOutlet var royalsOnEdgeCell:UITableViewCell!;
	
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
		var size = self.traitCollection.horizontalSizeClass;
		switch size
		{
			case UIUserInterfaceSizeClass.Compact:
				kingsInTheCornerDescription.font = kingsInTheCornerDescription.font.fontWithSize(16);
			default:
				kingsInTheCornerDescription.font = kingsInTheCornerDescription.font.fontWithSize(24);
		}
		royalsOnEdgeDescription.font = kingsInTheCornerDescription.font;
	}
	
	override func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!)
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
	
	override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
	{
		// Clear the table cell selection.  Animating this causes
		// the nice gentle flash when the user taps the row.
		tableView.deselectRowAtIndexPath(indexPath, animated: true);
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)
	{
		// Since this view is beign displayed as a popover, it needs
		// to be dismissed before the incoming view is displayed.
		self.dismissViewControllerAnimated(true, completion: nil);
		
		// Make sure the segue is coming from a table cell...
		if let cell = sender as? UITableViewCell
		{
			// Make sure the cell refers to a game mode...
			if let mode = GameMode.fromRaw(cell.reuseIdentifier.uppercaseString)
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