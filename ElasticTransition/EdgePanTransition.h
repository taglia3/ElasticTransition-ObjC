//
//  EdgePanTransition.h
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface EdgePanTransition : NSObject  <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning,UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property (nonatomic) CGFloat   panThreshold;
@property (nonatomic) Edge      edge;

@property (nonatomic) BOOL  transitioning;
@property (nonatomic) BOOL  presenting;
@property (nonatomic) BOOL  interactive;
@property (nonatomic) BOOL  navigation;

@property (nonatomic) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic) UIView *container;


@property (nonatomic) CGSize    size;

@property (nonatomic) UIView    *frontView;
@property (nonatomic) UIView    *backView;
@property (nonatomic) UIViewController *frontViewController;
@property (nonatomic) UIViewController *backViewController;

@property (nonatomic) UIView    *toView;
@property (nonatomic) UIView *  fromView;
@property (nonatomic) UIViewController *toViewController;
@property (nonatomic) UIViewController *fromViewController;

@property (nonatomic) UIPanGestureRecognizer *currentPanGR;

@property (nonatomic) CGPoint translation;
@property (nonatomic) CGPoint dragPoint;


-(void)update;
-(void)setup;

-(void)clean:(BOOL)finished;

-(void)cancelInteractiveTransition;
-(void)finishInteractiveTransition;

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;

-(BOOL)updateInteractiveTransitionWithGestureRecognizer:(UIPanGestureRecognizer*) pan;

-(void)startInteractiveTransitionFromViewController:(UIViewController*)fromViewController SegueIdentifier:(NSString*)identifier GestureRecognizer:(UIPanGestureRecognizer*)pan;

-(void)startInteractiveTransitionFromViewController:(UIViewController*)fromViewController ToViewController:(UIViewController*)toViewController GestureRecognizer:(UIPanGestureRecognizer*)pan;

-(void)dismissInteractiveTransitionViewController:(UIViewController*)viewController GestureRecognizer:(UIPanGestureRecognizer*)pan Completion:(void (^)(void))completion;



@end
