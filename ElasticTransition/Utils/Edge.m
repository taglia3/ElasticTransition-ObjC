//
//  Edge.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//


#import "Edge.h"

@implementation Edge

@synthesize type;

-(id)initWithEdgeType:(EdgeType)theType{
    
    self = [super init];
    
    if(self){
        self.type = theType;
    }
    return self;
}

- (EdgeType)opposite{
    
    switch (self.type) {
            
        case LEFT:
            return RIGHT;
        case RIGHT:
            return LEFT;
        case BOTTOM:
            return TOP;
        case TOP:
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

@end
