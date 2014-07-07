//
//  GameViewController+collectionViewDataSource.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 7/6/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

extension GameViewController
{
	func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int
	{
		return 1;
	}
	
	func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int
	{
		return 16;
	}
	
	func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath:NSIndexPath) -> UICollectionViewCell
	{
		var tableViewCell = UICollectionViewCell();
		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Card Spot Cell", forIndexPath: indexPath) as? CardSpotCell
		{
			cell.index = indexPath.row;
			self.gameModeController?.setMarkerImage(cell);
			cell.modeController = self.gameModeController;
			tableViewCell = cell;
		};
		return tableViewCell;
	}
}
