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

-(void)update{
    
    [super update];
    
    if (self.cb != nil && self.lb != nil){
        
        CGPoint initialPoint = [self finalPoint:[NSNumber numberWithBool:!self.presenting]];
        
        
        
        CGPoint p = (self.useTranlation && self.interactive) ? [self translatedPoint] : self.dragPoint;
        
        switch (self.edge.type){
        case LEFT:
            {
                self.cb.point = CGPointMake(p.x < self.contentLength ? p.x : (p.x - self.contentLength)/3.0 + self.contentLength, self.dragPoint.y);
                self.lb.point = CGPointMake(MIN(self.contentLength, CGPointDistance(p, initialPoint) < self.stickDistance ? initialPoint.x : p.x), self.dragPoint.y);
            }
        case RIGHT:
            {
                CGFloat maxX = self.size.width - self.contentLength;
                self.cb.point = CGPointMake(p.x > maxX ? p.x : maxX - (maxX - p.x)/3.0, self.dragPoint.y);
                self.lb.point = CGPointMake(MAX(maxX, CGPointDistance(p, initialPoint) < self.stickDistance ? initialPoint.x : p.x), self.dragPoint.y);
            }
        case BOTTOM:
            {
                CGFloat maxY = self.size.height - self.contentLength;
                self.cb.point = CGPointMake(self.dragPoint.x, p.y > maxY ? p.y : maxY - (maxY - p.y)/3.0);
                self.lb.point = CGPointMake(self.dragPoint.x, MAX(maxY, CGPointDistance(p, initialPoint) < self.stickDistance ? initialPoint.y : p.y));
            }
        case TOP:
            {
                self.cb.point = CGPointMake(self.dragPoint.x, p.y < self.contentLength ? p.y : (p.y-self.contentLength)/3.0+self.contentLength);
                self.lb.point = CGPointMake(self.dragPoint.x, MIN(self.contentLength, CGPointDistance(p, initialPoint) < self.stickDistance ? initialPoint.y : p.y));
            }
        }
    }
}


-(void)updateShape{
    
    if (self.animator == nil){
        return;
    }
    
    self.backView.layer.zPosition = 0;
    self.overlayView.layer.zPosition = 298;
    self.shadowView.layer.zPosition = 299;
    self.frontView.layer.zPosition = 300;
    
    CGPoint finalPoint = [self finalPoint:[NSNumber numberWithBool:YES]];
    CGPoint initialPoint = [self finalPoint:[NSNumber numberWithBool:NO]];
    
    
    CGFloat progress = 1.0 - (CGPointDistance(self.lc.center, finalPoint) / CGPointDistance(initialPoint, finalPoint));
    
    switch (self.edge.type){
            
    case LEFT:
        {
            CGRect frame = self.frontView.frame;
            frame.origin.x = MIN(self.cc.center.x, self.lc.center.x) - self.contentLength;
            self.frontView.frame = frame;
            self.shadowMaskLayer.frame = CGRectMake(0, 0, self.lc.center.x, self.size.height);
        }
    case RIGHT:
        {
            CGRect frame = self.frontView.frame;
            frame.origin.x = MAX(self.cc.center.x, self.lc.center.x);
            self.frontView.frame = frame;
            self.shadowMaskLayer.frame = CGRectMake(self.lc.center.x, 0, self.size.width - self.lc.center.x, self.size.height);
        }
    case BOTTOM:
        {
            CGRect frame = self.frontView.frame;
            frame.origin.y = MAX(self.cc.center.y, self.lc.center.y);
            self.frontView.frame = frame;
        self.shadowMaskLayer.frame = CGRectMake(0, self.lc.center.y, self.size.width, self.size.height - self.lc.center.y);
        }
    case TOP:
        {
            CGRect frame = self.frontView.frame;
            frame.origin.y = MIN(self.cc.center.y, self.lc.center.y) - self.contentLength;
            self.frontView.frame = frame;
        self.shadowMaskLayer.frame = CGRectMake(0, 0, self.size.width, self.lc.center.y);
        }
    }
    self.shadowMaskLayer.dragPoint = [self.shadowMaskLayer convertPoint:self.cc.center fromLayer:self.container.layer];

    
    if (self.transform != nil){
        
      //  transform!(progress: progress, view: backView)
    }else{
        // transform backView
        switch (self.transformType){
        case ROTATE:
            {
                CGFloat scale = MIN(1, 1.0 - 0.2 * progress);
                CGFloat rotate = MAX(0, 0.15 * progress);
                CGFloat rotateY = self.edge.type == LEFT ? -1.0 : self.edge.type == RIGHT ? 1.0 : 0;
                CGFloat rotateX = self.edge.type == BOTTOM ? -1.0 : self.edge.type == TOP ? 1.0 : 0;
            
                CATransform3D t = CATransform3DMakeScale(scale, scale, 1);
                t.m34 = 1.0 / -500;
                t = CATransform3DRotate(t, rotate, rotateX, rotateY, 0.0);
                self.backView.layer.transform = t;
            }
            case TRANSLATEMID:
            case TRANSLATEPULL:
            case TRANSLATEPUSH:
            {
                CGFloat x = 0;
                CGFloat y = 0;
                
                self.container.backgroundColor = self.backView.backgroundColor;
                
                NSString *minFunctionType = self.transformType == TRANSLATEMID ?  @"1" : self.transformType == TRANSLATEPULL ?  @"3" :  @"2";
                NSString *maxFunctionType = self.transformType == TRANSLATEMID ?  @"1" : self.transformType == TRANSLATEPULL ?  @"2" :  @"3";
                
                
                
                
                
                
            switch (self.edge.type){
            case LEFT:
                {
                    if ([minFunctionType isEqualToString:@"1"]) {
                        x = [HelperFunctions avgOfA:self.cc.center.x AndB: self.lc.center.x];
                    }else if ([minFunctionType isEqualToString:@"2"]) {
                        x = MIN(self.cc.center.x, self.lc.center.x);
                    }else if ([minFunctionType isEqualToString:@"3"]) {
                        x = MAX(self.cc.center.x, self.lc.center.x);
                    }
                }
            case RIGHT:
                {
                    if ([maxFunctionType isEqualToString:@"1"]) {
                        x = [HelperFunctions avgOfA:self.cc.center.x AndB: self.lc.center.x] - self.size.width;
                    }else if ([maxFunctionType isEqualToString:@"2"]) {
                        x = MIN(self.cc.center.x, self.lc.center.x) - self.size.width;
                    }else if ([maxFunctionType isEqualToString:@"3"]) {
                        x = MAX(self.cc.center.x, self.lc.center.x) - self.size.width;
                    }
                }
            case BOTTOM:
                {
                    if ([maxFunctionType isEqualToString:@"1"]) {
                        y = [HelperFunctions avgOfA:self.cc.center.y AndB: self.lc.center.y] - self.size.height;
                    }else if ([maxFunctionType isEqualToString:@"2"]) {
                        y = MIN(self.cc.center.y, self.lc.center.y) - self.size.height;
                    }else if ([maxFunctionType isEqualToString:@"3"]) {
                        y = MAX(self.cc.center.y, self.lc.center.y) - self.size.height;
                    }
                }
            case TOP:
                {
                    if ([minFunctionType isEqualToString:@"1"]) {
                        y = [HelperFunctions avgOfA:self.cc.center.y AndB: self.lc.center.y];
                    }else if ([minFunctionType isEqualToString:@"2"]) {
                        y = MIN(self.cc.center.y, self.lc.center.y);
                    }else if ([minFunctionType isEqualToString:@"3"]) {
                        y = MAX(self.cc.center.y, self.lc.center.y);
                    }
                    
                }
            }
                self.backView.layer.transform = CATransform3DMakeTranslation(x, y, 0);
        }
        default:
                self.backView.layer.transform = CATransform3DIdentity;
        }
    }
    
    self.overlayView.alpha = progress;
    
    [self updateShadow:progress];
    
    [self.transitionContext updateInteractiveTransition:(self.presenting ? progress : 1.0 - progress)];
    
}


-(void)setup{
    
    [super setup];
    
    // 1. get content length
    [self.frontView layoutIfNeeded];
    
    switch (self.edge.type){
        case LEFT:
        case RIGHT:
            self.contentLength = self.frontView.bounds.size.width;
        case TOP:
        case BOTTOM:
            self.contentLength = self.frontView.bounds.size.height;
    }
    
    if let vc = frontViewController as? ElasticMenuTransitionDelegate,
        let vcl = vc.contentLength{
            contentLength = vcl
        }
    
    
    // 2. setup shadow and background view
    self.shadowView.frame = self.container.bounds;
    if let frontViewBackgroundColor = frontViewBackgroundColor{
        shadowMaskLayer.fillColor = frontViewBackgroundColor.CGColor
    }else if let vc = frontViewController as? UINavigationController,
        let rootVC = vc.childViewControllers.last{
            shadowMaskLayer.fillColor = rootVC.view.backgroundColor?.CGColor
        }else{
            shadowMaskLayer.fillColor = frontView.backgroundColor?.CGColor
        }
    shadowMaskLayer.edge = edge.opposite()
    shadowMaskLayer.radiusFactor = radiusFactor
    container.addSubview(shadowView)
    
    
    // 3. setup overlay view
    overlayView.frame = container.bounds
    overlayView.backgroundColor = overlayColor
    overlayView.addGestureRecognizer(backgroundExitPanGestureRecognizer)
    container.addSubview(overlayView)
    
    // 4. setup front view
    var rect = container.bounds
    switch edge{
    case .Right, .Left:
        rect.size.width = contentLength
    case .Bottom, .Top:
        rect.size.height = contentLength
    }
    frontView.frame = rect
    if navigation{
        frontViewController.navigationController?.view.addGestureRecognizer(navigationExitPanGestureRecognizer)
    }else{
        frontView.addGestureRecognizer(foregroundExitPanGestureRecognizer)
    }
    frontView.layoutIfNeeded()
    
    // 5. container color
    switch transformType{
    case .TranslateMid, .TranslatePull, .TranslatePush:
        container.backgroundColor = backView.backgroundColor
    default:
        container.backgroundColor = containerColor
    }
    
    // 6. setup uikitdynamic
    setupDynamics()
    
    // 7. do a initial update (put everything into its place)
    updateShape()
    
    // if not doing an interactive transition, move the drag point to the final position
    if !interactive{
        let duration = self.transitionDuration(transitionContext)
        lb.action = {
            if self.animator != nil && self.animator.elapsedTime() >= duration {
                self.cc.center = self.dragPoint
                self.lc.center = self.dragPoint
                self.updateShape()
                self.clean(true)
            }
        }
        
        dragPoint = self.startingPoint ?? container.center
        dragPoint = finalPoint()
        update()
    }
}



@end
