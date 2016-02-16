//
//  OptionsViewController.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "OptionsViewController.h"

#import "SwitchCellModel.h"

#import "SwitchCell.h"
#import "SliderCell.h"
#import "SegmentCell.h"

@interface OptionsViewController ()<CellStateChange>{
    
    ElasticTransition *tm;
    NSMutableArray *menuItems;
}

@end


@implementation OptionsViewController

@synthesize contentLength, dismissByBackgroundDrag, dismissByBackgroundTouch, dismissByForegroundDrag;

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.contentLength = 0.0;
        self.dismissByBackgroundTouch   = YES;
        self.dismissByBackgroundDrag    = YES;
        self.dismissByForegroundDrag    = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    tm = (ElasticTransition*)self.transitioningDelegate;
    
    
    NSMutableArray *va = [[NSMutableArray alloc] init];
    [va addObject:[NSNumber numberWithInt:NONE]];
    [va addObject:[NSNumber numberWithInt:ROTATE]];
    [va addObject:[NSNumber numberWithInt:TRANSLATEMID]];

    
    menuItems = [[NSMutableArray alloc] init];
    
    SwitchCellModel *stickySwitchModel = [[SwitchCellModel alloc]init];
    stickySwitchModel.name  = @"Sticky";
    stickySwitchModel.on    = tm.sticky;
    stickySwitchModel.rowHeigth = 54.0;
    stickySwitchModel.type = STICKY;
    stickySwitchModel.delegate = self;
    [menuItems addObject:stickySwitchModel];
    
    SwitchCellModel *shadowSwitchModel = [[SwitchCellModel alloc]init];
    shadowSwitchModel.name  = @"Shadow";
    shadowSwitchModel.on    = tm.showShadow;
    shadowSwitchModel.rowHeigth = 54.0;
    shadowSwitchModel.type = SHADOW;
    shadowSwitchModel.delegate = self;
    [menuItems addObject:shadowSwitchModel];
    
    
    for (int i = 0 ; i < menuItems.count; i++) {
        
        self.contentLength += [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    NSLog(@"[OptionsViewController] Content length: %f", self.contentLength);
    
    [self.tableView reloadData];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
        case 1:
        {
            SwitchCellModel *itemModel = (SwitchCellModel *) [menuItems objectAtIndex:indexPath.row];
           
            
            SwitchCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
            switchCell.cellModel = itemModel;
            cell = switchCell;
        
            break;
        }
        case 2:
        {
            
        }
        default:
            break;
    }

    
    return cell;
    
}
 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return menuItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSObject *itemModel = [menuItems objectAtIndex:indexPath.row];
    
    if ([[itemModel class] conformsToProtocol:@protocol(CellDimensionAndTypeDelegate)]) {
        NSObject <CellDimensionAndTypeDelegate> *item = (NSObject <CellDimensionAndTypeDelegate> *) itemModel;
        
        return item.rowHeigth;
        
    }else{
        return 0.0;
    }
}


-(void)didChangeStateToOn:(BOOL)on AndPropertyRelated:(PropertyRelated)property{

    switch (property) {
        case STICKY:
            tm.sticky = on;
            break;
        case SHADOW:
            tm.showShadow = on;
            break;
        default:
            break;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
