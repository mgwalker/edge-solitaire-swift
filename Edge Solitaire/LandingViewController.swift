//
//  ViewController.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 6/2/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit
import QuartzCore

extension UIViewController
{
	func setBackground()
	{
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Felt - Green"));
	}
	
	func prefersStatusBarHidden() -> Bool
	{
		return true;
	}
}

class LandingViewController: UIViewController {
                            
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController.navigationBarHidden = true;
		self.setBackground();
	}
}

