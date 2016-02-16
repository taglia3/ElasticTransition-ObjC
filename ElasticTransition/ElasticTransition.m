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

@property (nonatomic) NSMutableArray < UIViewController* > *pushedControllers;
@property (nonatomic) UIPanGestureRecognizer *backgroundExitPanGestureRecognizer;
@property (nonatomic) UIPanGestureRecognizer *foregroundExitPanGestureRecognizer;
@property (nonatomic) UIScreenEdgePanGestureRecognizer * navigationExitPanGestureRecognizer;


@end

@implementation ElasticTransition

@synthesize damping, transformType;
@synthesize contentLength;

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        self.radiusFactor   = 0.5;
        self.sticky         = TRUE;
        self.containerColor = [UIColor colorWithRed:152.0/255.0 green:174.0/255.0 blue:196.0/255.0 alpha:1.0];
        self.overlayColor   = [UIColor colorWithRed:152.0/255.0 green:174.0/255.0 blue:196.0/255.0 alpha:0.5];
        self.showShadow     = FALSE;
        self.shadowColor    = [UIColor colorWithRed:100.0/255.0 green:122.0/255.0 blue:144.0/255.0 alpha:1.0];
        self.shadowRadius   = 50.0;
        
        self.transformType  = TRANSLATEMID;
        
        NSLog(@"[ElasticTransition] %@", [self transformTypeToString]);

        self.startingPoint = CGPointZero;
        
    
        self.contentLength  = 0.0;
        self.lastPoint      = CGPointZero;
        
        self.useTranlation  = TRUE;
        self.damping        = 0.2f;
        
        self.overlayView    = [[UIView alloc] init];
        self.shadowView     = [[UIView alloc] init];
        
        self.shadowMaskLayer = [[ElasticShapeLayer alloc] init];
        
        self.pushedControllers                  = [[NSMutableArray alloc] init];
        self.backgroundExitPanGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        self.foregroundExitPanGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        self.navigationExitPanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] init];
        
        
        self.backgroundExitPanGestureRecognizer.delegate = self;
        [self.backgroundExitPanGestureRecognizer addTarget:self action:@selector(handleOffstagePan:)];
        
        self.foregroundExitPanGestureRecognizer.delegate = self;
        [self.foregroundExitPanGestureRecognizer addTarget:self action:@selector(handleOffstagePan:)];
        
        self.navigationExitPanGestureRecognizer.delegate = self;
        [self.navigationExitPanGestureRecognizer addTarget:self action:@selector(handleOffstagePan:)];
        
        self.navigationExitPanGestureRecognizer.edges = [HelperFunctions oppositeAndToUIRectEdgeOfEdge:self.edge];
        
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

-(void)transformWithProgress:(CGFloat)progress AndView:(UIView*)view{
    
}

-(void)setContentLength:(CGFloat)aContentLength{
    
    self->contentLength = aContentLength;
    
    self.stickDistance = self.sticky ? self.contentLength * self.panThreshold : 0.0;
    
    NSLog(@"stickDistance: %f", self.stickDistance);
}


-(void)setEdge:(Edge)edge{
    
    [super setEdge:edge];
    
    self.navigationExitPanGestureRecognizer.edges = [HelperFunctions oppositeAndToUIRectEdgeOfEdge:edge];
}

-(void)setTransformType:(ElasticTransitionBackgroundTransform)aTransformType{
    
    self->transformType= aTransformType;
    
    if (self.container != nil){
        
        [self.container layoutIfNeeded];
    }
}

-(void)setDamping:(CGFloat)aDamping{
    
    self->damping = MIN(1.0, MAX(0.0, aDamping));
}

- (CGPoint)finalPoint{
    
    BOOL p = self.presenting;
    
//    NSLog(@"presenting è nil");
//    NSLog(@"%@| self %@", p ? @"1" : @"0", self.presenting ? @"Yes" : @"No");
    
    switch (self.edge){
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

- (CGPoint)finalPoint:(BOOL)presentingIn{
    
    BOOL p = presentingIn;
    
//    NSLog(@"presenting: %@", presentingIn ? @"1" : @"0");
//    NSLog(@"%@| self %@", p ? @"1" : @"0", self.presenting ? @"Yes" : @"No");
    
    switch (self.edge){
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
    
    CGPoint initialPoint = [self finalPoint: !self.presenting];
    
    switch (self.edge){
        case LEFT:
        case RIGHT:
            return CGPointMake(MAX(0,MIN(self.size.width,initialPoint.x + self.translation.x)), initialPoint.y);
        case TOP:
        case BOTTOM:
            return CGPointMake(initialPoint.x, MAX(0,MIN(self.size.height,initialPoint.y + self.translation.y)));
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
            
            if ([[vc class] conformsToProtocol:@protocol(ElasticMenuTransitionDelegate)]) {
                
                UIViewController <ElasticMenuTransitionDelegate> *vcc = (UIViewController <ElasticMenuTransitionDelegate> *) self.frontViewController;
                return  vcc.dismissByBackgroundDrag;
            }else{
                return FALSE;
            }
            
        }else if (gestureRecognizer == self.foregroundExitPanGestureRecognizer){
            
            if ([[vc class] conformsToProtocol:@protocol(ElasticMenuTransitionDelegate)]) {
                
                UIViewController <ElasticMenuTransitionDelegate> *vcc = (UIViewController <ElasticMenuTransitionDelegate> *) self.frontViewController;
                return  vcc.dismissByForegroundDrag;
            }else{
                return FALSE;
            }
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
                break;
            default:
                [self updateInteractiveTransitionWithGestureRecognizer:pan];
                break;
        }
    }
}

-(void)overlayTapped:(UITapGestureRecognizer*)tapGR{
    
    UIViewController *vc = [self.pushedControllers lastObject];
    
    if (vc){
        
        BOOL touchToDismiss;
        
        if ([[vc class] conformsToProtocol:@protocol(ElasticMenuTransitionDelegate)]) {
            
            UIViewController <ElasticMenuTransitionDelegate> *vcc = (UIViewController <ElasticMenuTransitionDelegate> *) self.frontViewController;
            touchToDismiss =   vcc.dismissByBackgroundTouch;
        }
        
        if (touchToDismiss){
            
            [vc dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void)update{
    
    [super update];
    
    if (self.cb != nil && self.lb != nil){
        
        CGPoint initialPoint = [self finalPoint: !self.presenting];
        
        CGPoint p = (self.useTranlation && self.interactive) ? [self translatedPoint] : self.dragPoint;
        
        switch (self.edge){
            case LEFT:
            {
                self.cb.point = CGPointMake(p.x < self.contentLength ? p.x : (p.x - self.contentLength)/3.0 + self.contentLength, self.dragPoint.y);
                self.lb.point = CGPointMake(MIN(self.contentLength, CGPointDistance(p, initialPoint) < self.stickDistance ? initialPoint.x : p.x), self.dragPoint.y);
                break;
            }
            case RIGHT:
            {
                CGFloat maxX = self.size.width - self.contentLength;
                self.cb.point = CGPointMake(p.x > maxX ? p.x : maxX - (maxX - p.x)/3.0, self.dragPoint.y);
                self.lb.point = CGPointMake(MAX(maxX, CGPointDistance(p, initialPoint) < self.stickDistance ? initialPoint.x : p.x), self.dragPoint.y);
                break;
            }
            case BOTTOM:
            {
                CGFloat maxY = self.size.height - self.contentLength;
                self.cb.point = CGPointMake(self.dragPoint.x, p.y > maxY ? p.y : maxY - (maxY - p.y)/3.0);
                self.lb.point = CGPointMake(self.dragPoint.x, MAX(maxY, CGPointDistance(p, initialPoint) < self.stickDistance ? initialPoint.y : p.y));
                break;
            }
            case TOP:
            {
                self.cb.point = CGPointMake(self.dragPoint.x, p.y < self.contentLength ? p.y : (p.y-self.contentLength)/3.0+self.contentLength);
                self.lb.point = CGPointMake(self.dragPoint.x, MIN(self.contentLength, CGPointDistance(p, initialPoint) < self.stickDistance ? initialPoint.y : p.y));
                break;
            }
        }
        
        
        NSLog(@"cb.point:(%.1f,%.1f) | lb.point:(%.1f,%.1f)", self.cb.point.x, self.cb.point.y, self.lb.point.x, self.lb.point.y);
    }
}


-(void)updateShape{
    
    if (self.animator == nil){
        return;
    }
    
    /*
    UIViewController *fromVCC = self.fromViewController;
    UIViewController *toVCC = self.toViewController;
    UIViewController *frontVCC = self.frontViewController;
    UIViewController *backVCC = self.backViewController;
    */
    
    self.backView.layer.zPosition       = 0;
    self.overlayView.layer.zPosition    = 298;
    self.shadowView.layer.zPosition     = 299;
    self.frontView.layer.zPosition      = 300;
    
    CGPoint finalPoint      = [self finalPoint:YES];
    CGPoint initialPoint    = [self finalPoint:NO];
    
    
    CGFloat progress = 1.0 - (CGPointDistance(self.lc.center, finalPoint) / CGPointDistance(initialPoint, finalPoint));
    
    
    switch (self.edge){
            
        case LEFT:
        {
            CGRect frame = self.frontView.frame;
            frame.origin.x = MIN(self.cc.center.x, self.lc.center.x) - self.contentLength;
            self.frontView.frame = frame;
            self.shadowMaskLayer.frame = CGRectMake(0, 0, self.lc.center.x, self.size.height);
            break;
        }
        case RIGHT:
        {
            CGRect frame = self.frontView.frame;
            frame.origin.x = MAX(self.cc.center.x, self.lc.center.x);
            self.frontView.frame = frame;
            self.shadowMaskLayer.frame = CGRectMake(self.lc.center.x, 0, self.size.width - self.lc.center.x, self.size.height);
            break;
        }
        case BOTTOM:
        {
            CGRect frame = self.frontView.frame;
            frame.origin.y = MAX(self.cc.center.y, self.lc.center.y);
            self.frontView.frame = frame;
            self.shadowMaskLayer.frame = CGRectMake(0, self.lc.center.y, self.size.width, self.size.height - self.lc.center.y);
            break;
        }
        case TOP:
        {
            CGRect frame = self.frontView.frame;
            frame.origin.y = MIN(self.cc.center.y, self.lc.center.y) - self.contentLength;
            self.frontView.frame = frame;
            self.shadowMaskLayer.frame = CGRectMake(0, 0, self.size.width, self.lc.center.y);
            break;
        }
    }
    self.shadowMaskLayer.dragPoint = [self.shadowMaskLayer convertPoint:self.cc.center fromLayer:self.container.layer];
    
    
    if (false){
        
        //  transform!(progress: progress, view: backView)
    }else{
        // transform backView
        switch (self.transformType){
            case ROTATE:
            {
                CGFloat scale = MIN(1, 1.0 - 0.2 * progress);
                CGFloat rotate = MAX(0, 0.15 * progress);
                CGFloat rotateY = self.edge == LEFT ? -1.0 : self.edge == RIGHT ? 1.0 : 0;
                CGFloat rotateX = self.edge == BOTTOM ? -1.0 : self.edge == TOP ? 1.0 : 0;
                
                CATransform3D t = CATransform3DMakeScale(scale, scale, 1);
                t.m34 = 1.0 / -500;
                t = CATransform3DRotate(t, rotate, rotateX, rotateY, 0.0);
                self.backView.layer.transform = t;
                break;
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
                
                
                
                switch (self.edge){
                    case LEFT:
                    {
                        if ([minFunctionType isEqualToString:@"1"]) {
                            x = [HelperFunctions avgOfA:self.cc.center.x AndB: self.lc.center.x];
                        }else if ([minFunctionType isEqualToString:@"2"]) {
                            x = MIN(self.cc.center.x, self.lc.center.x);
                        }else if ([minFunctionType isEqualToString:@"3"]) {
                            x = MAX(self.cc.center.x, self.lc.center.x);
                        }
                        break;
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
                        break;
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
                        break;
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
                        break;
                    }
                }
                
                NSLog(@"Translation: (%.1f, %.1f)", x, y);
                
                self.backView.layer.transform = CATransform3DMakeTranslation(x, y, 0);
                
                break;
            }
            default:
                
                self.backView.layer.transform = CATransform3DIdentity;
                break;
        }
    }
    
    NSLog(@"progress: %f", progress);
    
    self.overlayView.alpha = progress;
    
    [self updateShadow:progress];
    
    [self.transitionContext updateInteractiveTransition:(self.presenting ? progress : 1.0 - progress)];
}


-(void)setup{
    
    [super setup];
    
    // 1. get content length
    [self.frontView layoutIfNeeded];
    
    switch (self.edge){
        case LEFT:
        case RIGHT:
            self.contentLength = self.frontView.bounds.size.width;
            break;
        case TOP:
        case BOTTOM:
            self.contentLength = self.frontView.bounds.size.height;
            break;
    }
    
    if ([[self.frontViewController class] conformsToProtocol:@protocol(ElasticMenuTransitionDelegate)]) {
        
        UIViewController <ElasticMenuTransitionDelegate> *vc = (UIViewController <ElasticMenuTransitionDelegate> *) self.frontViewController;
        CGFloat vcl = vc.contentLength;
        self.contentLength = vcl;
    }
    
    
    // 2. setup shadow and background view
    self.shadowView.frame = self.container.bounds;
    
    
    if (self.frontViewBackgroundColor){
        
        self.shadowMaskLayer.fillColor = self.frontViewBackgroundColor.CGColor;
    }else if ([self.frontViewController isKindOfClass:[UINavigationController class]]){
        
        UINavigationController *vc = (UINavigationController*) self.frontViewController;
        
        UIViewController *rootVC = [vc.childViewControllers lastObject];
        
        self.shadowMaskLayer.fillColor = rootVC.view.backgroundColor.CGColor;
    }else{
        self.shadowMaskLayer.fillColor = self.frontView.backgroundColor.CGColor;
        
        
    }
    
    self.shadowMaskLayer.edge = [HelperFunctions oppositeOfEdge:self.edge];
    self.shadowMaskLayer.radiusFactor = self.radiusFactor;
    [self.container addSubview:self.shadowView];
    
    
    // 3. setup overlay view
    self.overlayView.frame              = self.container.bounds;
    self.overlayView.backgroundColor    = self.overlayColor;
    [self.overlayView addGestureRecognizer:self.backgroundExitPanGestureRecognizer];
    [self.container addSubview:self.overlayView];
    
    // 4. setup front view
    CGRect rect = self.container.bounds;
    switch (self.edge){
        case LEFT:
        case RIGHT:
            rect.size.width = self.contentLength;
            break;
        case TOP:
        case BOTTOM:
            rect.size.height = self.contentLength;
            break;
    }
    
    self.frontView.frame = rect;
    
    if (self.navigation){
        
        [self.frontViewController.navigationController.view addGestureRecognizer:self.navigationExitPanGestureRecognizer];
    }else{
        
        [self.frontView addGestureRecognizer:self.foregroundExitPanGestureRecognizer];
    }
    
    [self.frontView layoutIfNeeded];
    
    
    // 5. container color
    switch (self.transformType){
        case TRANSLATEMID:
        case TRANSLATEPULL:
        case TRANSLATEPUSH:
            self.container.backgroundColor = self.backView.backgroundColor;
            break;
        default:
            self.container.backgroundColor = self.containerColor;
            break;
    }
    
    // 6. setup uikitdynamic
    [self setupDynamics];
    
    // 7. do a initial update (put everything into its place)
    [self updateShape];
    
    // if not doing an interactive transition, move the drag point to the final position
    if (!self.interactive){
        
        CGFloat duration = [self transitionDuration:self.transitionContext];
        
        __weak typeof(self) weakSelf = self;
        
        self.lb.action = ^{
            
            if ((weakSelf.animator != nil) && ([weakSelf.animator elapsedTime] >= duration)) {
                
                weakSelf.cc.center = weakSelf.dragPoint;
                weakSelf.lc.center = weakSelf.dragPoint;
                [weakSelf updateShape];
                [weakSelf clean:true];
            }
        };
        
        
        if(self.startingPoint.x != 0 || self.startingPoint.y != 0){
            
            self.dragPoint = self.startingPoint;
        }else{
            
            self.dragPoint = self.container.center;
        }
        
        self.dragPoint = [self finalPoint];
        [self update];
    }
}



-(void)updateShadow:(CGFloat)progress{
    
    if (self.showShadow){
        
        self.shadowView.layer.shadowColor = self.shadowColor.CGColor;
        self.shadowView.layer.shadowRadius = self.shadowRadius;
        self.shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        self.shadowView.layer.shadowOpacity = progress;
        self.shadowView.layer.masksToBounds = false;
    }else{
        
        self.shadowView.layer.shadowColor = nil;
        self.shadowView.layer.shadowRadius = 0;
        self.shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        self.shadowView.layer.shadowOpacity = 0;
        self.shadowView.layer.masksToBounds = true;
    }
}

-(void)setupDynamics{
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.container];
    CGPoint initialPoint = [self finalPoint:!self.presenting];
    
    self.cc = [[DynamicItem alloc] initWithCenter:initialPoint];
    self.lc = [[DynamicItem alloc] initWithCenter:initialPoint];
    
    self.cb = [[CustomSnapBehavior alloc] initWithItem:self.cc Point:self.dragPoint];
    self.cb.damping = self.damping;
    self.cb.frequency = 2.5;
    self.lb = [[CustomSnapBehavior alloc] initWithItem:self.lc Point:self.dragPoint];
    self.lb.damping = MIN(1.0, self.damping * 1.5);
    self.lb.frequency = 2.5;
    
    [self update];
    
    __weak typeof(self) weakSelf = self;
    
    self.cb.action = ^{
        [weakSelf updateShape];
    };
    
    [self.animator addBehavior:self.cb];
    [self.animator addBehavior:self.lb];
}

-(void)clean:(BOOL)finished{
    
    [self.animator removeAllBehaviors];
    
    self.animator = nil;
    
    self.frontView.layer.zPosition = 0;
    
    if (self.navigation){
        
        [self.shadowView removeFromSuperview];
        [self.overlayView removeFromSuperview];
    }
    if (self.presenting && finished){
        
        [self.pushedControllers addObject:self.frontViewController];
    }else if (!self.presenting && finished){
        [self.pushedControllers removeLastObject];
    }
    
    [super clean:finished];
}

-(void)cancelInteractiveTransition{
    
    [super cancelInteractiveTransition];
    
    CGPoint finalPoint = [self finalPoint:!self.presenting];
    
    self.cb.point = finalPoint;
    self.lb.point = finalPoint;
    
    __weak typeof(self) weakSelf = self;
    
    
    self.lb.action = ^{
        
        if (CGPointDistance(finalPoint, weakSelf.cc.center) < 1 && CGPointDistance(finalPoint, weakSelf.lc.center) < 1 && CGPointDistance(weakSelf.lastPoint, weakSelf.cc.center) < 0.05){
            
            weakSelf.cc.center = finalPoint;
            weakSelf.lc.center = finalPoint;
            
            [weakSelf updateShape];
            [weakSelf clean:false];
        }else{
            
            [weakSelf updateShape];
        }
        weakSelf.lastPoint = weakSelf.cc.center;
    };
}

-(void)finishInteractiveTransition{
    
    [super finishInteractiveTransition];
    
    CGPoint finalPoint = [self finalPoint];
    
    self.cb.point = finalPoint;
    self.lb.point = finalPoint;
    
    __weak typeof(self) weakSelf = self;
    
    self.lb.action = ^{
        
        if (CGPointDistance(finalPoint, weakSelf.cc.center) < 1 && CGPointDistance(finalPoint, weakSelf.lc.center) < 1 && CGPointDistance(weakSelf.lastPoint, weakSelf.cc.center) < 0.05){
            
            weakSelf.cc.center = finalPoint;
            weakSelf.lc.center = finalPoint;
            
            [weakSelf updateShape];
            [weakSelf clean:true];
        }else{
            [weakSelf updateShape];
        }
        weakSelf.lastPoint = weakSelf.cc.center;
    };
}

-(BOOL)endInteractiveTransition{
    
    CGPoint finalPoint      = [self finalPoint];
    CGPoint initialPoint    = [self finalPoint:!self.presenting];
    
    CGPoint p = (self.useTranlation && self.interactive) ? [self translatedPoint] : self.dragPoint;
    
    if ((CGPointDistance(p, initialPoint) >= self.contentLength * self.panThreshold) && (CGPointDistance(initialPoint, finalPoint) > CGPointDistance(p, finalPoint))){
        
        [self finishInteractiveTransition];
        return true;
    } else {
        [self cancelInteractiveTransition];
        return false;
    }
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return (ABS(self.damping - 0.2) * 0.5 + 0.6);
}


-(NSString*)transformTypeToString{
    
    switch (self.transformType) {
        case NONE:
            return @"NONE";
        case ROTATE:
            return @"ROTATE";
        case TRANSLATEMID:
            return @"TRANSLATEMID";
        case TRANSLATEPULL:
            return @"TRANSLATEPULL";
        case TRANSLATEPUSH:
            return @"TRANSLATEPUSH";
    }
}

@end
