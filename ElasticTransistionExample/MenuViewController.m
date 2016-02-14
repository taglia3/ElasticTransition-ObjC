//
//  MenuViewController.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize contentLength, dismissByBackgroundDrag, dismissByBackgroundTouch, dismissByForegroundDrag;


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.contentLength = 320;
        self.dismissByBackgroundTouch = true;
        self.dismissByBackgroundDrag = true;
        self.dismissByForegroundDrag = true;
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ElasticTransition *tm = (ElasticTransition*)self.transitioningDelegate;
    
    self.textView.text = [NSString stringWithFormat:@"transition.edge = %@\ntransition.transformType = %@\ntransition.sticky = %@\ntransition.showShadow = %@", [HelperFunctions typeToStringOfEdge:tm.edge], [tm transformTypeToString], tm.sticky ? @"YES" : @"NO", tm.showShadow ? @"YES" : @"NO"];
    
    self.codeView2.text =[NSString stringWithFormat:@"Codice di inizializzazione"];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
