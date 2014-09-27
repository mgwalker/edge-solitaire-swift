//
//  GameViewController+viewDidLayoutSubviews.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 7/6/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

// This extension sets up the view with UIView overrides
extension GameViewController
{
	override func viewDidLoad()
	{
		self.setBackground();
	}
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated);
		showGameStats();
		self.startNewGame(nil);
	}
	
	// We don't know what size the collection view will be until
	// this method is called.  Now we can figure out what size to
	// make the card cells.
	override func viewDidLayoutSubviews()
	{
		super.viewDidLayoutSubviews();
		
		// Get the layout for the collection view.
		let layout = self.cardCollection.collectionViewLayout as UICollectionViewFlowLayout;
		
		// The size of the collection view.  Dur.
		var containerSize = self.cardCollection.bounds.size;
		
		var itemSize = CGSize(width: 0, height: 0);	// Initial item size
		var itemSpacing:CGFloat = 0;				// Initial horizontal spacing between cells
		var lineSpacing:CGFloat = 0;				// Initial vertical spacing between cells
		
		// The aspect ratio of card images is 1:1.4.  If 1.4 times the width is
		// less than the height, then we have excess vertical space and are
		// constrained by the width.
		if containerSize.width * 1.4 < containerSize.height
		{
			// Fixed horizontal spacing at 10
			itemSpacing = 10;
			
			// Now figure out the width.  The itemSpacing appears five times in
			// the layout - three times between cells, plus once each on the left
			// and right insets.
			itemSize.width = (containerSize.width - (itemSpacing * 5)) / 4;
			
			// And now compute the height.
			itemSize.height = itemSize.width * 1.4;
			
			// Finally, compute the vertical spacing between the cells to fill
			// up the excess height.
			lineSpacing = (containerSize.height - (itemSize.height * 4)) / 5;
		}
		// Or else we have excess horizontal space and are height-constraint.
		else
		{
			// And we essentially do the same set of calculations, but being
			// height-constrained instead of width.
			
			lineSpacing = 10;
			itemSize.height = (containerSize.height - (lineSpacing * 5)) / 4;
			itemSize.width = itemSize.height / 1.4;
			
			itemSpacing = (containerSize.width - (itemSize.width * 4)) / 5;
		}
		
		// Calculate the horizontal (left/right) and vertical (top/bottom) insets.
		// These will come to exactly 10 for whichever dimension is constrained
		// thanks to the glorious calculations above.
		let hInset = (containerSize.width - ((itemSize.width * 4) + (itemSpacing * 3))) / 2.0;
		let vInset = (containerSize.height - ((itemSize.height * 4) + (lineSpacing * 3))) / 2.0;
		
		// Now update the layout with the computed values.
		layout.itemSize = itemSize;
		layout.minimumInteritemSpacing = itemSpacing;
		layout.minimumLineSpacing = lineSpacing;
		layout.sectionInset = UIEdgeInsets(top: vInset, left: hInset, bottom: vInset, right: hInset);
	}
}
