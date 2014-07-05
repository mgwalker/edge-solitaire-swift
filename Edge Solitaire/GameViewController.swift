//
//  GameViewController.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 6/10/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit

class CardSpotCell:UICollectionViewCell
{
	@IBOutlet var imageView:UIImageView;
}

class GameViewController:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate
{
	@IBOutlet var cardCollection:UICollectionView;
	@IBOutlet var nextCard:UIImageView;
	
	var deck:Card[] = [];
	
	var gameModeController:GameModeControllerProtocol?;
	
	override func viewDidLoad()
	{
		self.setBackground();
		deck = Card.newDeck();
	}
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated);
		self.nextCard.image = CardHelper.imageForCard(Card(suit: Card.Suit.Club, rank: Card.Rank.Eight));
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
			cell.imageView.image = CardHelper.imageForCard(deck[indexPath.row]);
			tableViewCell = cell;
		};
		return tableViewCell;
	}
}