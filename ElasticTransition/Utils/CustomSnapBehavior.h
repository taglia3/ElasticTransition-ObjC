//
//  CustomSnapBehavior.h
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSnapBehavior : UIDynamicBehavior

@property (nonatomic) CGPoint point;
@property (nonatomic) CGFloat frequency;
@property (nonatomic) CGFloat damping;

-(id)initWithItem:(id <UIDynamicItem>)item Point:(CGPoint)point;

@end
