//
//  OptionsViewController.h
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElasticTransition.h"


@interface SwitchCell:UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UISwitch *control;

-(IBAction)switchChanged:(UISwitch*)sender;

@end

@interface SliderCell:UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UISlider *slider;

-(IBAction)sliderChanged:(UISlider*)sender;

@end

@interface SegmentCell:UITableViewCell

@property (nonatomic) NSMutableArray *values;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segment;

-(IBAction)segmentChanged:(UISegmentedControl*)sender;

@end


@interface OptionsViewController : UIViewController <ElasticMenuTransitionDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
