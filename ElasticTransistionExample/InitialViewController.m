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
    transition.sticky = true;
    transition.showShadow = true;
    transition.panThreshold = 0.3;
    transition.transformType = TRANSLATEMID;
    
    //    transition.overlayColor = UIColor(white: 0, alpha: 0.5)
    //    transition.shadowColor = UIColor(white: 0, alpha: 0.5)
    
    // gesture recognizer
    lgr = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [lgr addTarget:self action:@selector(handlePan:)];
    rgr = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [rgr addTarget:self action:@selector(handleRightPan:)];
    lgr.edges = LEFT;
    rgr.edges = RIGHT;
    [self.view addGestureRecognizer:lgr];
    [self.view addGestureRecognizer:rgr];
}

-(void)handlePan:(UIPanGestureRecognizer*)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan){
        transition.edge.type = LEFT;
        [transition startInteractiveTransitionFromViewController:self SegueIdentifier:@"menu" GestureRecognizer:pan];
    }else{
        [transition updateInteractiveTransitionWithGestureRecognizer:pan];
    }
}

-(void)handleRightPan:(UIPanGestureRecognizer*)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan){
        transition.edge.type = RIGHT;
        [transition startInteractiveTransitionFromViewController:self SegueIdentifier:@"about" GestureRecognizer:pan];
    }else{
        [transition updateInteractiveTransitionWithGestureRecognizer:pan];
    }
}


@end
