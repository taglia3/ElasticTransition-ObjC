//
//  HelperFunctions.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 13/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "HelperFunctions.h"

@implementation HelperFunctions

+ (Edge)oppositeOfEdge:(Edge)e{
    
    switch (e) {
            
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

+ (UIRectEdge)toUIRectEdgeOfEdge:(Edge)e{
    
    switch (e) {
            
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

+ (UIRectEdge)oppositeAndToUIRectEdgeOfEdge:(Edge)e{
    
    [self oppositeOfEdge:e];
    
    return [self toUIRectEdgeOfEdge:e];
}

+ (NSString*)typeToStringOfEdge:(Edge)e{
    
    switch (e) {
            
        case LEFT:
            return @"LEFT";
        case RIGHT:
            return @"RIGHT";
        case BOTTOM:
            return @"BOTTOM";
        case TOP:
            return @"TOP";
    }
}

+(CGFloat)avgOfA:(CGFloat)a AndB:(CGFloat)b{
    
    return (a+b)/2.0;
}

@end
