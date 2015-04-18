//
//  LandingViewController.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 6/2/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import UIKit
import QuartzCore

// Add some functionality to all of our view controllers rather
// than implementing it everywhere.  Cheers for extensions and
// inheritance!  Goodbye, Objective-C!
extension UIViewController
{
	func setBackground()
	{
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Felt - Green")!);
	}
	
	// And this one is really an override of the UIViewController
	// base class, but apparently the override keyword doesn't
	// work on extensions, so that's kind of weird.
	//@objc override func prefersStatusBarHidden() -> Bool
	//{
	//	return true;
	//}
}

// The landing view is the very first one, which makes sense.
// This view will probably go away because there's no point
// stopping here.  There's nothing to see and nothing happens
// until you touch the button...  so get rid of the button and
// just do the thing.
class LandingViewController: UIViewController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.navigationController?.navigationBarHidden = true;
		self.setBackground();
	}
}

