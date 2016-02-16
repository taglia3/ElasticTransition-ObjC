//
//  EdgePanTransition.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "EdgePanTransition.h"


@interface EdgePanTransition ()

@end


@implementation EdgePanTransition

@synthesize currentPanGR;


-(id)init{
    
    self = [super init];
    
    if (self) {
        
        self.panThreshold   = 0.2;
        self.edge           = RIGHT;
        
        NSLog(@"[EdgePanTransition] %@" , [HelperFunctions typeToStringOfEdge:self.edge]);
        
        self.transitioning  = NO;
        self.presenting     = YES;
        self.interactive    = NO;
        self.navigation     = NO;
        
        self.translation    = CGPointZero;
        self.dragPoint      = CGPointZero;
    }
    
    return self;
}

-(CGSize)size{
    return self.container.bounds.size;
}

-(UIView*)frontView{
    return self.frontViewController.view;
}

-(UIView*)backView{
    return self.backViewController.view;
}

-(UIViewController*)frontViewController{
    return self.presenting ? self.toViewController : self.fromViewController;
}

-(UIViewController*)backViewController{
    return !self.presenting ? self.toViewController : self.fromViewController;
}

-(UIView*)toView{
    return self.toViewController.view;
}

-(UIView*)fromView{
    return self.fromViewController.view;
}

-(UIViewController*)toViewController{
    return [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
}

-(UIViewController*)fromViewController{
    return [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
}

-(void)update{

}

-(void)setup{
    
    self.transitioning = YES;
    
    [self.container addSubview:self.backView];
    [self.container addSubview:self.frontView];
}

-(void)clean:(BOOL)finished{
    
    if (!self.navigation) {
        
        if (finished) {
            
            [[UIApplication sharedApplication].keyWindow  addSubview:self.toView];
        }else{
            
            [[UIApplication sharedApplication].keyWindow  addSubview:self.fromView];
        }
    }
    
    if (self.presenting && !self.interactive){
        
        [self.backViewController viewWillAppear:YES];
    }
    
    if((!self.presenting && finished) || (self.presenting && !finished)){
        
        [self.frontView removeFromSuperview];
        self.backView.layer.transform = CATransform3DIdentity;
        [self.backViewController viewDidAppear:YES];
    }
    
    self.currentPanGR   = nil;
    self.interactive    = false;
    self.transitioning  = false;
    self.navigation     = false;
    [self.transitionContext completeTransition:finished];
}

-(void)startInteractivePresentFromViewController:(UIViewController*)fromVC ToViewController:(UIViewController*)toVC SegueIdentifier:(NSString*)identifier GestureRecognizer:(UIPanGestureRecognizer*)pan Presenting:(BOOL)presenting Completion:(void (^)(void))completion{
    
    self.interactive = YES;
    self.currentPanGR = pan;
    
    
    if (presenting){
        
        
        if (identifier){
            
            [fromVC performSegueWithIdentifier:identifier sender:self];
            
        }else if (toVC){
            
            [fromVC presentViewController:toVC animated:YES completion:nil];
        }
    }else{
        
        if (self.navigation){
            
            [fromVC.navigationController popViewControllerAnimated:YES];
        }else{
            
            [fromVC dismissViewControllerAnimated:YES completion:completion];
        }
    }
    
    self.translation    = [pan translationInView:pan.view];
    self.dragPoint      = [pan locationInView:pan.view];
    
    NSLog(@"START T:(%.1f,%.1f)\tD:(%.1f,%.1f)", self.translation.x, self.translation.y, self.dragPoint.x, self.dragPoint.y);
}


-(BOOL)updateInteractiveTransitionWithGestureRecognizer:(UIPanGestureRecognizer*) pan{
    

    if (!self.transitioning){
       
        return NO;
    }
    
    NSLog(@"UPDATE YES");
    
    if (pan.state == UIGestureRecognizerStateChanged){
        
        self.translation    = [pan translationInView:pan.view];
        self.dragPoint      = [pan locationInView:pan.view];
        
        NSLog(@"UPDATE T:(%.1f,%.1f)\tD:(%.1f,%.1f)", self.translation.x, self.translation.y, self.dragPoint.x, self.dragPoint.y);
        
        [self update];
        
        return NO;
    }else{
        
        return [self endInteractiveTransition];
    }
}

-(void)startInteractiveTransitionFromViewController:(UIViewController*)fromViewController SegueIdentifier:(NSString*)identifier GestureRecognizer:(UIPanGestureRecognizer*)pan{
    
    [self startInteractivePresentFromViewController:fromViewController ToViewController:nil SegueIdentifier:identifier GestureRecognizer:pan Presenting:YES Completion:nil];
}

-(void)startInteractiveTransitionFromViewController:(UIViewController*)fromViewController ToViewController:(UIViewController*)toViewController GestureRecognizer:(UIPanGestureRecognizer*)pan{
    
    [self startInteractivePresentFromViewController:fromViewController ToViewController:toViewController SegueIdentifier:nil GestureRecognizer:pan Presenting:YES Completion:nil];
}

-(void)dismissInteractiveTransitionViewController:(UIViewController*)viewController GestureRecognizer:(UIPanGestureRecognizer*)pan Completion:(void (^)(void))completion{
    
    [self startInteractivePresentFromViewController:viewController ToViewController:nil SegueIdentifier:nil GestureRecognizer:pan Presenting:NO Completion:completion];
}


-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    self.transitionContext = transitionContext;
    self.container = [self.transitionContext containerView];
    [self setup];
}


-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    [self animateTransition:transitionContext];
}

-(void)cancelInteractiveTransition{
    [self.transitionContext cancelInteractiveTransition];
}

-(void)finishInteractiveTransition{
    
    if (!self.presenting){
        
        [self.backViewController viewWillAppear:YES];
    }
    
    [self.transitionContext finishInteractiveTransition];
}

-(BOOL)endInteractiveTransition{
    
    BOOL finished;
    
    UIPanGestureRecognizer *pan = self.currentPanGR;
    
    if (pan){
        
        CGPoint translation = [pan translationInView:pan.view];
        
        CGFloat progress;
        
        switch (self.edge){
            
        case LEFT:
                progress =  translation.x / pan.view.frame.size.width;
                break;
        case RIGHT:
                progress =  translation.x / pan.view.frame.size.width * -1;
                break;
        case BOTTOM:
                progress =  translation.y / pan.view.frame.size.height * -1;
                break;
        case TOP:
                progress =  translation.y / pan.view.frame.size.height;
                break;
        }
        
        progress = self.presenting ? progress : -progress;
        
        if(progress > self.panThreshold){
            
            finished = true;
        } else {
            
            finished = false;
        }
    }else{
        
        finished = true;
    }
    
    if (finished){
        
        [self finishInteractiveTransition];
    }else{
        
        [self cancelInteractiveTransition];
    }
    
    return finished;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.7;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    self.presenting = true;
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    self.presenting = false;
    return self;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    
    self.presenting = true;
    return self.interactive ? self : nil;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    
    self.presenting = false;
    return self.interactive ? self : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    
    return self.interactive ? self : nil;
}


-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    self.navigation = true;
    self.presenting = (operation == UINavigationControllerOperationPush);
    return self;
}

@end
