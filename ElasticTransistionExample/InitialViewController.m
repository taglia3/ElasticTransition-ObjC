//
//  InitialViewController.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "InitialViewController.h"

#import "ElasticTransition.h"

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
    transition.sticky = YES;
    transition.showShadow = YES;
    transition.panThreshold = 0.3;
    transition.transformType = TRANSLATEMID;
    
    transition.overlayColor = [UIColor colorWithWhite:0 alpha:0.5];
    transition.shadowColor  = [UIColor colorWithWhite:0 alpha:0.5];
    
    // gesture recognizer
    lgr = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [lgr addTarget:self action:@selector(handlePan:)];
    lgr.edges = LEFT;
    [self.view addGestureRecognizer:lgr];
    
    
    rgr = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [rgr addTarget:self action:@selector(handleRightPan:)];
    rgr.edges = RIGHT;
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


@end
