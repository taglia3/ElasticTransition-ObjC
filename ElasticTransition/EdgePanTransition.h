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
@property (nonatomic) UIView *container;

@property (nonatomic) CGSize size;

@property (nonatomic) BOOL transitioning;
@property (nonatomic) BOOL presenting;
@property (nonatomic) BOOL interactive;
@property (nonatomic) BOOL navigation;

@property (nonatomic) CGPoint translation;
@property (nonatomic) CGPoint dragPoint;

@property (nonatomic) UIView *frontView;
@property (nonatomic) UIView *backView;

@property (nonatomic) id <UIViewControllerContextTransitioning> transitionContext;


-(void)update;
-(void)setup;

-(BOOL)updateInteractiveTransitionWithGestureRecognizer:(UIPanGestureRecognizer*) pan;

-(void)startInteractiveTransitionFromViewController:(UIViewController*)fromViewController SegueIdentifier:(NSString*)identifier GestureRecognizer:(UIPanGestureRecognizer*)pan;

-(void)startInteractiveTransitionFromViewController:(UIViewController*)fromViewController ToViewController:(UIViewController*)toViewController GestureRecognizer:(UIPanGestureRecognizer*)pan;

-(void)dismissInteractiveTransitionViewController:(UIViewController*)viewController GestureRecognizer:(UIPanGestureRecognizer*)pan Completion:(void (^)(void))completion;


@end
