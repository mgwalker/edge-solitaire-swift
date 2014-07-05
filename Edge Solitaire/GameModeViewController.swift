//
//  GameModeViewController.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 6/3/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

class GameModeViewController:UITableViewController
{
	@IBOutlet var kingsInTheCornerDescription:UILabel;
	@IBOutlet var royalsOnEdgeDescription:UILabel;
	
	@IBOutlet var kingsInTheCornerCell:UITableViewCell;
	@IBOutlet var royalsOnEdgeCell:UITableViewCell;
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		self.setBackground();
	}
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated);
		
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
		if(indexPath.section == 0)
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
		tableView.deselectRowAtIndexPath(indexPath, animated: true);
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)
	{
		self.dismissViewControllerAnimated(true, completion: nil);
		if let cell = sender as? UITableViewCell
		{
			if let mode = GameMode.fromRaw(cell.reuseIdentifier.uppercaseString)
			{
				if let modeController = GameModeFactory.GetGameMode(mode)
				{
					if let vc = segue.destinationViewController as? GameViewController
					{
						vc.gameModeController = modeController;
					}
				}
			}
		}
	}
}