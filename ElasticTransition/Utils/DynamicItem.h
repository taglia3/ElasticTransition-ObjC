//
//  DinamicItem.h
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicItem : NSObject <UIDynamicItem>

@property(nonatomic, readwrite) CGRect bounds;
@property(nonatomic, readwrite) CGPoint center;
@property(nonatomic, readwrite) CGAffineTransform transform;

- (id)initWithCenter:(CGPoint) center;

@end
