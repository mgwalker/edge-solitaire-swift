//
//  GameViewController+collectionViewDataSource.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 7/6/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

// This extension implements the collection view data source.
extension GameViewController
{
	// We only ever have one section.
	func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int
	{
		return 1;
	}
	
	// And that section always has 16 rows.
	func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int
	{
		return 16;
	}
	
	func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath:NSIndexPath) -> UICollectionViewCell
	{
		var tableViewCell = UICollectionViewCell();	// Default empty cell
		
		// Make sure we can get a card spot cell
		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Card Spot Cell", forIndexPath: indexPath) as? CardSpotCell
		{
			// Set it up.  Index and mode controller.
			cell.index = indexPath.row;
			
			// Ask the mode controller to set the marker.
			self.gameModeController?.setMarkerImage(cell);
			
			// Save it off to the return variable.
			tableViewCell = cell;
		};
		
		return tableViewCell;
	}
}
