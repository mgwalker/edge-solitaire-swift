//
//  SumToTenChecker.swift
//  Edge Solitaire
//
//  Created by Greg Walker on 8/10/14.
//  Copyright (c) 2014 Greg Walker. All rights reserved.
//

import Foundation

struct SumToTenChecker
{
	static let validSumSets:[[Int:Int]] = [
		[ 1:4, 2:3 ],
		[ 1:4, 2:1, 4:1 ],
		[ 1:4, 3:2 ],
		[ 1:4, 6:1 ],
		
		[ 1:3, 2:2, 3:1 ],
		[ 1:3, 2:1, 5:1 ],
		[ 1:3, 3:1, 4:1 ],
		[ 1:3, 7:1 ],
		
		[ 1:2, 2:4 ],
		[ 1:2, 2:2, 3:2 ],
		[ 1:2, 2:2, 4:1 ],
		[ 1:2, 4:2 ],
		[ 1:2, 2:1, 6:1 ],
		[ 1:2, 3:1, 5:1 ],
		[ 1:2, 8:1 ],
		
		[ 1:1, 2:3, 3:1 ],
		[ 1:1, 3:3 ],
		[ 1:1, 2:1, 3:1, 4:1 ],
		[ 1:1, 2:2, 5:1 ],
		[ 1:1, 4:1, 5:1 ],
		[ 1:1, 3:1, 6:1 ],
		[ 1:1, 2:1, 7:1 ],
		[ 1:1, 9:1 ],
		
		[ 2:3, 4:1 ],
		
		[ 2:2, 3:1 ],
		[ 2:2, 6:1 ],
		
		[ 2:1, 3:1, 5:1 ],
		[ 2:1, 4:2 ],
		[ 2:1, 8:1 ],
		
		[ 3:2, 4:1 ],
		[ 3:1, 7:1 ],
		
		[ 4:1, 6:1 ],
		
		[ 5:2 ],
		
		[ 10:1 ]
	];
	
	static func hasSumToTen(values:[Int]) -> Bool
	{
		var testSet:Dictionary<Int, Int> = [ 1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0, 10:0 ];
		for value in values
		{
			testSet[value]!++;
		}
		
		var hasSum = false;
		setLoop: for validSumSet in validSumSets
		{
			for (value, count) in validSumSet
			{
				if testSet[value] < count
				{
					continue setLoop;
				}
			}
			
			hasSum = true;
			break setLoop;
		}
		
		return hasSum;
	}
}
