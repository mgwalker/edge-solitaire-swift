//
//  GameViewController+viewDidLayoutSubviews.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 7/6/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

extension GameViewController
{
	override func viewDidLoad()
	{
		self.setBackground();
	}
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated);
		self.nextCard.setBackgroundImage(CardHelper.imageForCard(deck[0]), forState: UIControlState.Normal);
	}
	
	override func viewDidLayoutSubviews()
	{
		super.viewDidLayoutSubviews();
		
		let layout = self.cardCollection.collectionViewLayout as UICollectionViewFlowLayout;
		
		var containerSize = self.cardCollection.bounds.size;
		var itemSize = CGSize(width: 0, height: 0);
		var itemSpacing:CGFloat = 0;
		var lineSpacing:CGFloat = 0;
		
		if containerSize.width * 1.4 < containerSize.height
		{
			itemSpacing = 10;
			itemSize.width = (containerSize.width - (itemSpacing * 5)) / 4;	// left/right insets, plus three spacers
			itemSize.height = itemSize.width * 1.4;
			
			lineSpacing = (containerSize.height - (itemSize.height * 4)) / 5;
		}
		else
		{
			lineSpacing = 10;
			itemSize.height = (containerSize.height - (lineSpacing * 5)) / 4; // top/right insets, plus three spacers
			itemSize.width = itemSize.height / 1.4;
			
			itemSpacing = (containerSize.width - (itemSize.width * 4)) / 5;
		}
		
		let hInset = (containerSize.width - ((itemSize.width * 4) + (itemSpacing * 3))) / 2.0;
		let vInset = (containerSize.height - ((itemSize.height * 4) + (lineSpacing * 3))) / 2.0;
		
		layout.itemSize = itemSize;
		layout.minimumInteritemSpacing = itemSpacing;
		layout.minimumLineSpacing = lineSpacing;
		layout.sectionInset = UIEdgeInsets(top: vInset, left: hInset, bottom: vInset, right: hInset);
	}
}
