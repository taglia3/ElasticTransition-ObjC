//
//  SliderCell.m
//  ElasticTransitionExample
//
//  Created by Tigielle on 16/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "SliderCell.h"

@implementation SliderCell

@synthesize type, rowHeigth;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.rowHeigth  = 62.0;
    }
    
    return self;
}

-(IBAction)sliderChanged:(UISlider*)sender{
    
    [self onChangeValue:sender.value];
}

-(void)onChangeValue:(CGFloat)value{
    
}

@end
