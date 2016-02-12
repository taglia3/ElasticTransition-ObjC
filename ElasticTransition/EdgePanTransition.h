//
//  EdgePanTransition.h
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Edge.h"

@interface EdgePanTransition : NSObject

@property (nonatomic) CGFloat panThreshold;
@property (nonatomic) Edge *edge;

@end
