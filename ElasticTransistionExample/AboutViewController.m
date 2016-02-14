//
//  AboutViewController.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController (){
    
    UIScreenEdgePanGestureRecognizer *rgr;
    UIScreenEdgePanGestureRecognizer *lgr;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [self getRandomColor];
    
    
    // gesture recognizer
    lgr = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [lgr addTarget:self action:@selector(handleLeftPan:)];
    lgr.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:lgr];
    
    
    rgr = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [rgr addTarget:self action:@selector(handleRightPan:)];
    rgr.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:rgr];
}

-(void)handleLeftPan:(UIPanGestureRecognizer*)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan){
        
        [self.transition dismissInteractiveTransitionViewController:self GestureRecognizer:pan Completion:nil];
    }else{
        
        [self.transition updateInteractiveTransitionWithGestureRecognizer:pan];
    }
}

-(void)handleRightPan:(UIPanGestureRecognizer*)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan){
        
        AboutViewController *nextViewController =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"about"];
        
        nextViewController.transition = self.transition;
        nextViewController.transitioningDelegate = self.transition;
        nextViewController.modalPresentationStyle = UIModalPresentationCustom;
        self.transition.edge = RIGHT;
        [self.transition startInteractiveTransitionFromViewController:self SegueIdentifier:@"menu" GestureRecognizer:pan];
    }else{
        
        [self.transition updateInteractiveTransitionWithGestureRecognizer:pan];
    }
}

-(IBAction)dismiss:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(UIColor*)getRandomColor{
    
    CGFloat randomRed   = drand48();
    CGFloat randomGreen = drand48();
    CGFloat randomBlue  = drand48();
    
    return [UIColor colorWithRed:randomRed green:randomGreen blue:randomBlue alpha:1.0];
}


@end
