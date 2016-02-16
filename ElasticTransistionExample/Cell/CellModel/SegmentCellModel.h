//
//  SegmentCellModel.h
//  ElasticTransitionExample
//
//  Created by Tigielle on 16/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellDimensionAndTypeDelegate.h"

@protocol CellSegmentChange;

@interface SegmentCellModel : NSObject <CellDimensionAndTypeDelegate>

@property (nonatomic) NSArray   *values;
@property (nonatomic) NSInteger index;
@property (nonatomic, weak) id<CellSegmentChange> delegate;

- (void)setSelcetedTransformIndex:(NSInteger)index;

@end


@protocol CellSegmentChange <NSObject>

@optional

-(void)didSelcetedTransformIndex:(NSInteger)index AndPropertyRelated:(PropertyRelated)property;

@end