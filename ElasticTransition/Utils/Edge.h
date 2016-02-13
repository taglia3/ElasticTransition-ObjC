//
//  Edge.h
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(int,EdgeType){
    TOP = 0,
    BOTTOM,
    LEFT,
    RIGHT
};

@interface Edge : NSObject

@property EdgeType type;

- (id)initWithEdgeType:(EdgeType)type;

- (EdgeType)opposite;
- (UIRectEdge)toUIRectEdge;

- (UIRectEdge)oppositeAndToUIRectEdge;

@end
