//
//  SwitchCell.h
//  ElasticTransitionExample
//
//  Created by Tigielle on 16/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchCellModel.h"

@interface SwitchCell : UITableViewCell

@property (nonatomic, weak) IBOutlet    UILabel             *nameLabel;
@property (nonatomic, weak) IBOutlet    UISwitch            *control;
@property (nonatomic, weak)             SwitchCellModel     *cellModel;

-(IBAction)switchChanged:(UISwitch*)sender;

@end
