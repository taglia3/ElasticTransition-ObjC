//
//  OptionsViewController.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "OptionsViewController.h"

#import "SwitchCellModel.h"
#import "SegmentCellModel.h"

#import "SwitchCell.h"
#import "SliderCell.h"
#import "SegmentCell.h"

#define kHeightSwitchCell 54
#define kHeightSegmentCell 72

@interface OptionsViewController ()<CellStateChange, CellSegmentChange>{
    
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
    [va addObject:@"NONE"];
    [va addObject:@"ROTATE"];
    [va addObject:@"TRANSLATE MID"];

    
    menuItems = [[NSMutableArray alloc] init];
    
    SwitchCellModel *stickySwitchModel = [[SwitchCellModel alloc]init];
    stickySwitchModel.name  = @"Sticky";
    stickySwitchModel.type = STICKY;
    stickySwitchModel.on    = tm.sticky;
    stickySwitchModel.rowHeigth = kHeightSwitchCell;
    stickySwitchModel.delegate = self;
    [menuItems addObject:stickySwitchModel];
    
    SwitchCellModel *shadowSwitchModel = [[SwitchCellModel alloc]init];
    shadowSwitchModel.name  = @"Shadow";
    shadowSwitchModel.type = SHADOW;
    shadowSwitchModel.on    = tm.showShadow;
    shadowSwitchModel.rowHeigth = kHeightSwitchCell;
    shadowSwitchModel.delegate = self;
    [menuItems addObject:shadowSwitchModel];
    
    SegmentCellModel *transformSegmentModel = [[SegmentCellModel alloc]init];
    transformSegmentModel.name  = @"Transform Type";
    transformSegmentModel.type = TRANSFORM;
    transformSegmentModel. values = [va copy];
    
    switch (tm.transformType) {
        case NONE:
            transformSegmentModel.index = 0;
            break;
        case ROTATE:
            transformSegmentModel.index = 1;
            break;
        case TRANSLATEMID:
        case TRANSLATEPULL:
        case TRANSLATEPUSH:
            transformSegmentModel.index = 2;
            break;
            
        default:
            break;
    }
    
    transformSegmentModel.rowHeigth = kHeightSegmentCell;
    transformSegmentModel.delegate = self;
    [menuItems addObject:transformSegmentModel];
    
    
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
            SegmentCellModel *itemModel = (SegmentCellModel *) [menuItems objectAtIndex:indexPath.row];
            
            SegmentCell *segmentCell = [tableView dequeueReusableCellWithIdentifier:@"segment" forIndexPath:indexPath];
            segmentCell.cellModel = itemModel;
            cell = segmentCell;
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
        NSObject <CellDimensionAndTypeDelegate> *itemProt = (NSObject <CellDimensionAndTypeDelegate> *) itemModel;
        
        return itemProt.rowHeigth;
        
    }else{
        return 0.0;
    }
}


#pragma mark - Listen to table changes

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

-(void)didSelcetedTransformIndex:(NSInteger)index AndPropertyRelated:(PropertyRelated)property{
    
    if (property == TRANSFORM) {
        
        switch (index) {
            case 0:
                tm.transformType = NONE;
                break;
            case 1:
                tm.transformType = ROTATE;
                break;
            case 2:
                tm.transformType = TRANSLATEMID;
                break;
            default:
                break;
        }
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
