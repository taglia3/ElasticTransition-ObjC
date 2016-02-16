//
//  SegmentCell.m
//  ElasticTransitionExample
//
//  Created by Tigielle on 16/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "SegmentCell.h"

@implementation SegmentCell

@synthesize type, rowHeigth;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.rowHeigth  = 72.0;
    }
    
    return self;
}

-(void)onChangeValue:(id)value{
    
}

-(IBAction)segmentChanged:(UISegmentedControl*)sender{
    
    [self onChangeValue:self.values[sender.selectedSegmentIndex]];
}

@end
