//
//  ElasticTransition.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "ElasticTransition.h"
#import "ElasticShapeLayer.h"
#import "Utils.h"

@interface ElasticTransition ()

@property (nonatomic) CALayer *maskLayer;
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) DynamicItem *cc;
@property (nonatomic) DynamicItem *lc;
@property (nonatomic) CustomSnapBehavior *cb;
@property (nonatomic) CustomSnapBehavior *lb;
@property (nonatomic) CGFloat contentLength;

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) CGFloat stickDistance;
@property (nonatomic) UIView *overlayView;
@property (nonatomic) UIView *shadowView;
@property (nonatomic) ElasticShapeLayer *shadowMaskLayer;

@property (nonatomic) NSArray < UIViewController* > *pushedControllers;
@property (nonatomic) UIPanGestureRecognizer *backgroundExitPanGestureRecognizer;
@property (nonatomic) UIPanGestureRecognizer *foregroundExitPanGestureRecognizer;
@property (nonatomic) UIScreenEdgePanGestureRecognizer * navigationExitPanGestureRecognizer;


@end

@implementation ElasticTransition

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        self.radiusFactor = 0.5;
        self.sticky = TRUE;
        self.containerColor = [UIColor colorWithRed:152.0/255.0 green:174.0/255.0 blue:196.0/255.0 alpha:1.0];
        self.overlayColor = [UIColor colorWithRed:152.0/255.0 green:174.0/255.0 blue:196.0/255.0 alpha:0.5];
        self.showShadow = FALSE;
        self.shadowColor = [UIColor colorWithRed:100.0/255.0 green:122.0/255.0 blue:144.0/255.0 alpha:0.5];
        self.shadowRadius = 50.0;
        
        self.transformType = TRANSLATEMID;
        
        self.useTranlation = TRUE;
        
        self.damping = 0.2;
        
        self.contentLength = 0.0;
        
        self.lastPoint = CGPointZero;
        
        self.maskLayer = [[CALayer alloc]  init];
        
        self.stickDistance = self.sticky ? self.contentLength*self.panThreshold : 0.0;
        
        self.overlayView = [[UIView alloc] init];
        self.shadowView = [[UIView alloc] init];
        
        self.shadowMaskLayer = [[ElasticShapeLayer alloc] init];
        

        self.backgroundExitPanGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        self.foregroundExitPanGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        self.navigationExitPanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] init];
        
        
        self.backgroundExitPanGestureRecognizer.delegate = self;
        [self.backgroundExitPanGestureRecognizer addTarget:self action:@selector(handleOffstagePan:)];
        
        self.foregroundExitPanGestureRecognizer.delegate = self;
        [self.foregroundExitPanGestureRecognizer addTarget:self action:@selector(handleOffstagePan:)];
        
        self.navigationExitPanGestureRecognizer.delegate = self;
        [self.navigationExitPanGestureRecognizer addTarget:self action:@selector(handleOffstagePan:)];
        
        self.navigationExitPanGestureRecognizer.edges = [self.edge oppositeAndToUIRectEdge];
        
        [self.shadowView.layer addSublayer: self.shadowMaskLayer];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
        [tapGR addTarget:self action:@selector(overlayTapped:)];
        
        self.overlayView.opaque = FALSE;
        [self.overlayView addGestureRecognizer:tapGR];
        self.shadowView.opaque = FALSE;
        self.shadowView.layer.masksToBounds = false;
        
        
    }
    return self;
}


-(void)setEdge:(Edge *)edge{
    
    self.navigationExitPanGestureRecognizer.edges = [edge oppositeAndToUIRectEdge];
    
}

-(void)setTransformType:(ElasticTransitionBackgroundTransform)transformType{
    
    if (self.container != nil){
        
        [self.container layoutIfNeeded];
    }
}

-(void)setDamping:(CGFloat)damping{
    
    self.damping = MIN(1.0, MAX(0.0, self.damping));
}




- (CGPoint)finalPoint:(NSNumber*)presentingIn{
    
    static BOOL p;
    
    if (presentingIn != nil) {
        
        p = p;
    }else{
        
        p = self.presenting;
    }
    
    switch (self.edge.type){
    case LEFT:
            return p ? CGPointMake(self.contentLength, self.dragPoint.y) : CGPointMake(0, self.dragPoint.y);
    case RIGHT:
            return p ? CGPointMake(self.size.width - self.contentLength, self.dragPoint.y) : CGPointMake(self.size.width, self.dragPoint.y);
    case BOTTOM:
            return p ? CGPointMake(self.dragPoint.x, self.size.height - self.contentLength) : CGPointMake(self.dragPoint.x, self.size.height);
    case TOP:
            return p ? CGPointMake(self.dragPoint.x, self.contentLength) : CGPointMake(self.dragPoint.x, 0);
    }
}

-(CGPoint) translatedPoint{
    
    
    CGPoint initialPoint = [self finalPoint: [NSNumber numberWithBool:self.presenting]];
    
    switch (self.edge.type){
        case LEFT:
            case RIGHT:
            return CGPointMake(MAX(0,MIN(self.size.width,initialPoint.x+self.translation.x)), initialPoint.y);
        case TOP:
        case BOTTOM:
            return CGPointMake(initialPoint.x, MAX(0,MIN(self.size.height,initialPoint.y+self.translation.y)));
    }
}


-(BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return  !self.transitioning;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:(UISlider.self)] ){
        return FALSE;
    }
    if (gestureRecognizer == self.navigationExitPanGestureRecognizer){
        return TRUE;
    }
    
    UIViewController *vc = [self.pushedControllers lastObject];
    
    if (vc){
        
            if (gestureRecognizer == self.backgroundExitPanGestureRecognizer){
                
                 id<ElasticMenuTransitionDelegate> strongDelegate = self.delegate;
                
                return  strongDelegate.dismissByBackgroundDrag;
                
            }else if (gestureRecognizer == self.foregroundExitPanGestureRecognizer){
                
                id<ElasticMenuTransitionDelegate> strongDelegate = self.delegate;
                
                return  strongDelegate.dismissByForegroundDrag;
            }
        
    }
    
    return FALSE;
}

-(void)handleOffstagePan:(UIPanGestureRecognizer*)pan{
    
    UIViewController *vc = [self.pushedControllers lastObject];
    
    if (vc){
        
        switch (pan.state) {
                
            case UIGestureRecognizerStateBegan:
                
                if (pan == self.navigationExitPanGestureRecognizer){
                    
                    self.navigation = TRUE;
                }
                [self dismissInteractiveTransitionViewController:vc GestureRecognizer:pan Completion:nil];
                
            default:
                
                [self updateInteractiveTransitionWithGestureRecognizer:pan];
        }
    }
}

-(void)overlayTapped:(UITapGestureRecognizer*)tapGR{
    
    UIViewController *vc = [self.pushedControllers lastObject];
    id<ElasticMenuTransitionDelegate> strongDelegate = self.delegate;
    
    if (vc && strongDelegate){
        
        BOOL touchToDismiss = strongDelegate.dismissByBackgroundTouch;
        
        if (touchToDismiss){
            
            [vc dismissViewControllerAnimated:YES completion:nil];
        }
    }
}




@end
