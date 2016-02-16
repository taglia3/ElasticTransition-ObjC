//
//  SegmentCellModel.m
//  ElasticTransitionExample
//
//  Created by Tigielle on 16/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "SegmentCellModel.h"

@implementation SegmentCellModel

@synthesize type, rowHeigth;
@synthesize name;


- (void)setSelcetedTransformIndex:(NSInteger)index{
    
    self.index = index;
    
    id<CellSegmentChange> strongDelegate = self.delegate;
    
    if([strongDelegate respondsToSelector:@selector(didSelcetedTransformIndex:AndPropertyRelated:)]){
        
        [strongDelegate didSelcetedTransformIndex:index AndPropertyRelated:TRANSFORM];
    }
}

@end
