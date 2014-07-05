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
		
		cardCollection.registerClass(CardSpotCell.self, forCellWithReuseIdentifier: "Card Collection View");
	}
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated);
		self.nextCard.image = CardHelper.imageForCard(Card(suit: Card.Suit.Club, rank: Card.Rank.Eight));
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
		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Card Collection View", forIndexPath: indexPath) as? CardSpotCell
		{
			cell.backgroundColor = UIColor.yellowColor();
			tableViewCell = cell;
		};
		return tableViewCell;
	}
}