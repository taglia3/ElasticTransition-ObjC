//
//  HelperFunctions.h
//  ElasticTransistionExample
//
//  Created by Tigielle on 13/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int,Edge){
    TOP,
    BOTTOM,
    LEFT,
    RIGHT
};


@interface HelperFunctions : NSObject

+ (Edge)oppositeOfEdge:(Edge)e;
+ (UIRectEdge)toUIRectEdgeOfEdge:(Edge)e;
+ (UIRectEdge)oppositeAndToUIRectEdgeOfEdge:(Edge)e;
+ (NSString*)typeToStringOfEdge:(Edge)e;

+(CGFloat)avgOfA:(CGFloat)a AndB:(CGFloat)b;

@end
