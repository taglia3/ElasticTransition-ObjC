//
//  OptionsViewController.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "OptionsViewController.h"


@implementation SwitchCell

-(void)onChangeOn:(BOOL)on{
    
}

-(IBAction)switchChanged:(UISwitch*)sender{
    
    [self onChangeOn:sender.on];
}

@end


@implementation SliderCell:UITableViewCell

-(void)onChangeValue:(CGFloat)value{
    
}

-(IBAction)sliderChanged:(UISlider*)sender{
    
    [self onChangeValue:sender.value];
}

@end


@implementation SegmentCell:UITableViewCell

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self){
        
        self.values = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)onChangeValue:(id)value{
    
}

-(IBAction)segmentChanged:(UISegmentedControl*)sender{
    
    [self onChangeValue:self.values[sender.selectedSegmentIndex]];
}

@end


@interface OptionsViewController (){
    
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
    
    
    ElasticTransition *tm = (ElasticTransition*)self.transitioningDelegate;
    
    
    NSMutableArray *va = [[NSMutableArray alloc] init];
    [va addObject:[NSNumber numberWithInt:NONE]];
    [va addObject:[NSNumber numberWithInt:ROTATE]];
    [va addObject:[NSNumber numberWithInt:TRANSLATEMID]];

    
    menuItems = [[NSMutableArray alloc] init];
    
    /*
    menu.append(.Switch(name: "Sticky", on:tm.sticky, onChange: {on in
        tm.sticky = on
    }))
    menu.append(.Switch(name: "Shadow", on:tm.showShadow, onChange: {on in
        tm.showShadow = on
    }))
    menu.append(LeftMenuType.Segment(name: "Transform Type",values:va,selected:tm.transformType.rawValue, onChange: {value in
        tm.transformType = value as! ElasticTransitionBackgroundTransform
    }))
    menu.append(.Slider(name: "Damping", value:Float(tm.damping), onChange: {value in
        tm.damping = CGFloat(value)
    }))
    menu.append(.Slider(name: "Radius Factor", value:Float(tm.radiusFactor)/0.5, onChange: {value in
        tm.radiusFactor = CGFloat(value) * CGFloat(0.5)
    }))
    menu.append(.Slider(name: "Pan Theashold", value:Float(tm.panThreshold), onChange: {value in
        tm.panThreshold = CGFloat(value)
    }))
    
    */
    self.contentLength = 300.0;
    
    for (int i = 0 ; i < menuItems.count; i++) {
        
        self.contentLength += [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    NSLog(@"[OptionsViewController] Content length: %f", self.contentLength);
    
  //  [self.tableView reloadData];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
/*
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell;
    
    switch (indexPath.row){
    case 0:
        {
            SwitchCell *switchCell = [tableView dequeueReusableCellWithIdentifier:"switch" forIndexPath:indexPath];
            switchCell.nameLabel.text = @"Switch cell";
            
        SwitchCell *switchCell = tableView.dequeueReusableCellWithIdentifier("switch", forIndexPath: indexPath) as! SwitchCell
        switchCell.onChange = onChange
        switchCell.nameLabel.text = name
        switchCell.control.on = on
        cell = switchCell
            break;
        }
    case 1:
        let segmentCell  = tableView.dequeueReusableCellWithIdentifier("segment", forIndexPath: indexPath) as! SegmentCell
        segmentCell.onChange = onChange
        segmentCell.nameLabel.text = name
        segmentCell.segment.removeAllSegments()
        segmentCell.values = values
        for v in values.reverse(){
            segmentCell.segment.insertSegmentWithTitle("\(v)", atIndex: 0, animated: false)
        }
        segmentCell.segment.selectedSegmentIndex = selected
        cell = segmentCell
            break;
    case 2:
        let sliderCell  = tableView.dequeueReusableCellWithIdentifier("slider", forIndexPath: indexPath) as! SliderCell
        sliderCell.onChange = onChange
        sliderCell.nameLabel.text = name
        sliderCell.slider.maximumValue = 1.0
        sliderCell.slider.minimumValue = 0
        sliderCell.slider.value = value
        cell = sliderCell
            break;
    }
    return cell
    
}
 */

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return menuItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row){
        case 0:
            return 54;
        case 1:
            return 62;
        default:
            return 72;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
