//
//  ElasticTransition.h
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "EdgePanTransition.h"

typedef NS_ENUM(int,ElasticTransitionBackgroundTransform){
    NONE,
    ROTATE,
    TRANSLATEMID,
    TRANSLATEPULL,
    TRANSLATEPUSH
};

@interface ElasticTransition : EdgePanTransition <UIGestureRecognizerDelegate>

/**
 The curvature of the elastic edge.
 
 lower radiusFactor means higher curvature
 value is clamped between 0 to 0.5
 */
@property (nonatomic) CGFloat radiusFactor;

/**
 Determines whether or not the view edge will stick to
 the initial position when dragged.
 
 **Only effective when doing a interactive transition**
 */
@property (nonatomic) BOOL sticky;

/**
 The initial position of the simulated drag when static animation is performed
 
 i.e. The static animation will behave like user is dragging from this point
 
 **Only effective when doing a static transition**
 */
@property (nonatomic) CGPoint startingPoint;

/**
 The background color of the container when doing the transition
 
 default:
 ```
 UIColor(red: 152/255, green: 174/255, blue: 196/255, alpha: 1.0)
 ```
 */
@property (nonatomic) UIColor *containerColor;

/**
 The color of the overlay when doing the transition
 
 default:
 ```
 UIColor(red: 152/255, green: 174/255, blue: 196/255, alpha: 0.5)
 ```
 */
@property (nonatomic) UIColor *overlayColor;

/**
 Whether or not to display the shadow. Will decrease performance.
 
 default: false
 */
@property (nonatomic) BOOL showShadow;

/**
 The shadow color of the container when doing the transition
 
 default:
 ```
 UIColor(red: 100/255, green: 122/255, blue: 144/255, alpha: 1.0)
 ```
 */
@property (nonatomic) UIColor *shadowColor;

/**
 The shadow color of the container when doing the transition
 
 default:
 ```
 UIColor(red: 100/255, green: 122/255, blue: 144/255, alpha: 1.0)
 ```
 */
@property (nonatomic) UIColor *frontViewBackgroundColor;

/**
 The shadow radius of the container when doing the transition
 
 default:
 ```
 50
 ```
 */
@property (nonatomic) CGFloat shadowRadius;



@property (nonatomic) ElasticTransitionBackgroundTransform transformType;

@property (nonatomic) BOOL useTranlation;

@property (nonatomic) CGFloat damping;


-(NSString*)transformTypeToString;

@end




@protocol ElasticMenuTransitionDelegate

@optional
@property (nonatomic) CGFloat contentLength;
@property (nonatomic) BOOL dismissByBackgroundTouch;
@property (nonatomic) BOOL dismissByBackgroundDrag;
@property (nonatomic) BOOL dismissByForegroundDrag;

@end
