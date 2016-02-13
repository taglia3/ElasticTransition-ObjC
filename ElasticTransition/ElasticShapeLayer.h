//
//  ElasticShapeLayer.h
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ElasticShapeLayer : CAShapeLayer

@property (nonatomic) Edge *edge;
@property (nonatomic) CGPoint dragPoint;
@property (nonatomic) CGFloat radiusFactor;

@end
