//
//  ElasticShapeLayer.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "ElasticShapeLayer.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ElasticShapeLayer ()

@end

@implementation ElasticShapeLayer

@synthesize edge;
@synthesize dragPoint;
@synthesize radiusFactor;

-(id)init{
    
    self = [super init];
    
    if(self){
        
        self.edge           = BOTTOM;
        self.dragPoint      = CGPointZero;
        self.radiusFactor   = 0.25;
        
        self.backgroundColor    = [UIColor clearColor].CGColor;
        self.fillColor          = [UIColor blackColor].CGColor;
        self.actions            = [NSDictionary dictionaryWithObjectsAndKeys:   [NSNull null], @"path",
                                                                                [NSNull null], @"position",
                                                                                [NSNull null], @"bounds",
                                                                                [NSNull null], @"fillColor",
                                                                                nil];
    }
    
    return self;
}

-(id)initWithLayer:(id)layer{
    
    self = [super initWithLayer:layer];
    
    if(self){
        
        self.edge           = BOTTOM;
        self.dragPoint      = CGPointZero;
        self.radiusFactor   = 0.25;
    }
    
    return self;
}

-(void)setEdge:(Edge)anEdge{
    
    self->edge = anEdge;
    
    self.path = [self currentPath];
}

-(void) setDragPoint:(CGPoint)aDragPoint{
    
    self->dragPoint = aDragPoint;
 
    self.path = [self currentPath];
}

-(void)setRadiusFactor:(CGFloat)aRadiusFactor{
    
    self->radiusFactor = aRadiusFactor;
    
    if (self.radiusFactor < 0.0) {
        
        self->radiusFactor = 0.0;
    }
}

-(CGPathRef)currentPath{
    
    CGPoint centerPoint = self.dragPoint;
    
    NSLog(@"D:(%.1f,%.1f)",self.dragPoint.x, self.dragPoint.y);
    
    CGPoint leftPoint, rightPoint, bottomRightPoint, bottomLeftPoint;
    
    
    switch (self.edge){
    case TOP:
            leftPoint = CGPointMake(0 - MAX(0,self.bounds.size.width/2.0 - self.dragPoint.x), CGRectGetMinY(self.bounds));
            rightPoint = CGPointMake(self.bounds.size.width + MAX(0,self.dragPoint.x - self.bounds.size.width/2), CGRectGetMinY(self.bounds));
            bottomRightPoint = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
            bottomLeftPoint = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds));
            break;
    case BOTTOM:
            leftPoint = CGPointMake(self.bounds.size.width + MAX(0,self.dragPoint.x - self.bounds.size.width/2), CGRectGetMaxY(self.bounds));
            rightPoint = CGPointMake(0 - MAX(0,self.bounds.size.width/2 - self.dragPoint.x), CGRectGetMaxY(self.bounds));
            bottomRightPoint = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds));
            bottomLeftPoint = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMinY(self.bounds));
            break;
    case LEFT:
            leftPoint = CGPointMake(CGRectGetMinX(self.bounds), self.bounds.size.height + MAX(0,self.dragPoint.y-self.bounds.size.height/2));
            rightPoint = CGPointMake(CGRectGetMinX(self.bounds), 0 - MAX(0,self.bounds.size.height/2 - self.dragPoint.y));
            bottomRightPoint = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMinY(self.bounds));
            bottomLeftPoint = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
            break;
    case RIGHT:
            leftPoint = CGPointMake(CGRectGetMaxX(self.bounds), 0 - MAX(0,self.bounds.size.height/2 - self.dragPoint.y));
            rightPoint = CGPointMake(CGRectGetMaxX(self.bounds), self.bounds.size.height + MAX(0,self.dragPoint.y-self.bounds.size.height/2));
            bottomRightPoint = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds));
            bottomLeftPoint = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds));
            break;
    }
    
    UIBezierPath *shapePath = [UIBezierPath new];
    
    [shapePath moveToPoint:leftPoint];
    
    
    if (self.radiusFactor >= 0.5){
        
        CGPoint rightControl, leftControl;
        
        switch (self.edge){
            case TOP:
            case BOTTOM:
                rightControl = CGPointMake((rightPoint.x - centerPoint.x)*0.8+centerPoint.x, centerPoint.y);
                leftControl = CGPointMake((centerPoint.x - leftPoint.x)*0.2+leftPoint.x, centerPoint.y);
                break;
            case LEFT:
            case RIGHT:
                rightControl = CGPointMake(centerPoint.x, (rightPoint.y - centerPoint.y)*0.8+centerPoint.y);
                leftControl = CGPointMake(centerPoint.x, (centerPoint.y - leftPoint.y)*0.2+leftPoint.y);
                break;
        }
        
        [shapePath addCurveToPoint:centerPoint
                     controlPoint1:leftPoint
                     controlPoint2:leftControl];
        
        [shapePath addCurveToPoint:rightPoint
                     controlPoint1:centerPoint
                     controlPoint2:rightControl];
        
    }else{
        
        CGPoint rightControl, leftControl, rightRightControl, leftLeftControl;
        
        switch (self.edge){
                
        case TOP:
                centerPoint.y += (centerPoint.y - CGRectGetMinY(self.bounds))/4.0;
                break;
        case BOTTOM:
                centerPoint.y += (centerPoint.y - CGRectGetMaxY(self.bounds))/4.0;
                break;
        case LEFT:
                centerPoint.x += (centerPoint.x - CGRectGetMinX(self.bounds))/4.0;
                break;
        case RIGHT:
                centerPoint.x += (centerPoint.x - CGRectGetMaxX(self.bounds))/4.0;
                break;
        }
        
        switch (self.edge){
                
            case TOP:
            case BOTTOM:
            {
                rightControl = CGPointMake((rightPoint.x - centerPoint.x)*self.radiusFactor+centerPoint.x, (centerPoint.y + rightPoint.y)/2.0);
                leftControl = CGPointMake((centerPoint.x - leftPoint.x)*(1.0-self.radiusFactor)+leftPoint.x, (centerPoint.y + leftPoint.y)/2.0);
                
                float rrCtrlY = 0.0;
                float llCtrlY = 0.0;
                
                if (centerPoint.y > rightPoint.y) {
                    rrCtrlY = MIN(centerPoint.y,rightPoint.y);
                }else{
                    rrCtrlY = MAX(centerPoint.y,rightPoint.y);
                }
                
                if (centerPoint.y > rightPoint.y) {
                    llCtrlY = MIN(centerPoint.y,leftPoint.y);
                }else{
                    llCtrlY = MAX(centerPoint.y,leftPoint.y);
                }
                
            
                rightRightControl = CGPointMake((rightPoint.x - centerPoint.x)*(2.0*self.radiusFactor)+centerPoint.x, rrCtrlY);
                leftLeftControl = CGPointMake((centerPoint.x - leftPoint.x)*(1.0-2.0*self.radiusFactor)+leftPoint.x,llCtrlY);
                break;
            }
            case LEFT:
            case RIGHT:
            {
                rightControl = CGPointMake((centerPoint.x + rightPoint.x)/2.0, (rightPoint.y - centerPoint.y)*self.radiusFactor+centerPoint.y);
                leftControl = CGPointMake((centerPoint.x + leftPoint.x)/2.0, (centerPoint.y - leftPoint.y)*(1.0-self.radiusFactor)+leftPoint.y);
                
                
                float rrCtrlX = 0.0;
                float llCtrlX = 0.0;
                
                if (centerPoint.x > rightPoint.x) {
                    rrCtrlX = MIN(centerPoint.x,rightPoint.x);
                }else{
                    rrCtrlX = MAX(centerPoint.x,rightPoint.x);
                }
                
                if (centerPoint.x > rightPoint.x) {
                    llCtrlX = MIN(centerPoint.x,leftPoint.x);
                }else{
                    llCtrlX = MAX(centerPoint.x,leftPoint.x);
                }
            
                rightRightControl = CGPointMake(rrCtrlX,(rightPoint.y - centerPoint.y)*(2.0*self.radiusFactor)+centerPoint.y);
                leftLeftControl = CGPointMake(llCtrlX, (centerPoint.y - leftPoint.y)*(1.0-2.0*self.radiusFactor)+leftPoint.y);
                break;
            }
        }
        
        [shapePath addCurveToPoint:leftControl
                     controlPoint1:leftPoint
                     controlPoint2:leftLeftControl];
        
        [shapePath addCurveToPoint:rightControl
                     controlPoint1:leftControl
                     controlPoint2:centerPoint];
        
        [shapePath addCurveToPoint:rightPoint
                     controlPoint1:rightControl
                     controlPoint2:rightRightControl];
        

        
    }
    
    [shapePath addLineToPoint:bottomRightPoint];
    [shapePath addLineToPoint:bottomLeftPoint];
    [shapePath addLineToPoint:leftPoint];
    [shapePath closePath];
    
    return shapePath.CGPath;
}

@end
