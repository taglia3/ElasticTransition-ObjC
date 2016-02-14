//
//  InitialViewController.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "InitialViewController.h"

#import "ElasticTransition.h"
#import "AboutViewController.h"

@interface InitialViewController (){
    
    ElasticTransition *transition;
    UIScreenEdgePanGestureRecognizer *rgr;
    UIScreenEdgePanGestureRecognizer *lgr;
}

@end

@implementation InitialViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    // customization
    transition = [[ElasticTransition alloc] init];
    
    transition.sticky           = YES;
    transition.showShadow       = YES;
    transition.panThreshold     = 0.3;
    transition.transformType    = TRANSLATEMID;
    transition.overlayColor     = [UIColor colorWithWhite:0 alpha:0.5];
    transition.shadowColor      = [UIColor colorWithWhite:0 alpha:0.5];
    
    
    // gesture recognizers
    lgr = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [lgr addTarget:self action:@selector(handlePan:)];
    lgr.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:lgr];
    
    rgr = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [rgr addTarget:self action:@selector(handleRightPan:)];
    rgr.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:rgr];
}

-(void)handlePan:(UIPanGestureRecognizer*)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan){
        
        transition.edge = LEFT;
        [transition startInteractiveTransitionFromViewController:self SegueIdentifier:@"menu" GestureRecognizer:pan];
    }else{
        
        [transition updateInteractiveTransitionWithGestureRecognizer:pan];
    }
}

-(void)handleRightPan:(UIPanGestureRecognizer*)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan){
        
        transition.edge = RIGHT;
        [transition startInteractiveTransitionFromViewController:self SegueIdentifier:@"about" GestureRecognizer:pan];
    }else{
        
        [transition updateInteractiveTransitionWithGestureRecognizer:pan];
    }
}

- (IBAction)codeBtnTouched:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    
    transition.edge = LEFT;
    transition.startingPoint = button.center;
    [self performSegueWithIdentifier:@"menu" sender:self];
}

- (IBAction)optionBtnTouched:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    
    transition.edge = BOTTOM;
    transition.startingPoint = button.center;
    [self performSegueWithIdentifier:@"option" sender:self];
}

- (IBAction)aboutBtnTouched:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    
    transition.edge = RIGHT;
    transition.startingPoint = button.center;
    [self performSegueWithIdentifier:@"about" sender:self];
}

- (IBAction)navigationBtnTouched:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    
    transition.edge = RIGHT;
    transition.startingPoint = button.center;
    [self performSegueWithIdentifier:@"navigation" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UIViewController *vc = segue.destinationViewController;
    vc.transitioningDelegate = transition;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    if ([segue.identifier isEqualToString:@"navigation"]){
        
        
        UINavigationController *vc = segue.destinationViewController;
        vc.transitioningDelegate = transition;
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.delegate = transition;
        
    }else{
        
        if ([vc isKindOfClass:[AboutViewController class]]) {
            
            AboutViewController *vc = segue.destinationViewController;
            vc.transitioningDelegate = transition;
            vc.modalPresentationStyle = UIModalPresentationCustom;
            vc.transition = transition;
        }
        
    }
}


@end
