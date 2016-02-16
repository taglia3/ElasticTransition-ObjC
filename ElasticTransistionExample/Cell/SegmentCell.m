//
//  SegmentCell.m
//  ElasticTransitionExample
//
//  Created by Tigielle on 16/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "SegmentCell.h"

@implementation SegmentCell

@synthesize cellModel, segment;

- (void)setCellModel:(SegmentCellModel *)aCellModel{
    
    self->cellModel = aCellModel;
    
    [self setSegments: aCellModel.values];
    
    self.nameLabel.text = aCellModel.name;
}


-(IBAction)segmentChanged:(UISegmentedControl*)sender{
    
    [self.cellModel setSelcetedTransformIndex:sender.selectedSegmentIndex];
}

- (void)setSegments:(NSArray *)segments
{
    [self.segment removeAllSegments];
    
    int i = 0;
    
    for (NSString *str in segments) {
        [self.segment insertSegmentWithTitle:str atIndex:i animated:NO];
        i++;
    }
    
    [self.segment setSelectedSegmentIndex:self.cellModel.index];
}

@end
