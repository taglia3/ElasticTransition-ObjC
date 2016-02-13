//
//  Edge.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//


#import "Edge.h"

@implementation Edge

-(id)initWithEdgeType:(EdgeType)type{
    
    self = [super init];
    
    if(self){
        self.type = type;
    }
    return self;
}

- (EdgeType)opposite{
    
    switch (self.type) {
            
        case LEFT:
            self.type = RIGHT;
            return RIGHT;
        case RIGHT:
            self.type = LEFT;
            return LEFT;
        case BOTTOM:
            self.type = TOP;
            return TOP;
        case TOP:
            self.type = BOTTOM;
            return BOTTOM;
    }
}

- (UIRectEdge)toUIRectEdge{
    
    switch (self.type) {
            
        case LEFT:
            return UIRectEdgeLeft;
        case RIGHT:
            return UIRectEdgeRight;
        case BOTTOM:
            return UIRectEdgeBottom;
        case TOP:
            return UIRectEdgeTop;
    }
}

- (UIRectEdge)oppositeAndToUIRectEdge{
    
    [self opposite];
    return [self toUIRectEdge];
}

@end
