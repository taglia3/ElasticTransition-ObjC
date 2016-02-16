//
//  SegmentCell.h
//  ElasticTransitionExample
//
//  Created by Tigielle on 16/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDimensionAndTypeDelegate.h"

@interface SegmentCell : UITableViewCell <CellDimensionAndTypeDelegate>

@property (nonatomic) NSMutableArray *values;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segment;

-(IBAction)segmentChanged:(UISegmentedControl*)sender;

@end
