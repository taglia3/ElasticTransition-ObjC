//
//  NavigationExampleViewController.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "NavigationExampleViewController.h"

@interface NavigationExampleViewController ()

@end

@implementation NavigationExampleViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [self getRandomColor];
    
}

-(IBAction)dismiss:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)showMore:(id)sender{
    
    NavigationExampleViewController *nextViewController =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"navigationExample"];
    
    [self.navigationController pushViewController:nextViewController animated:YES];
}

-(UIColor*)getRandomColor{
    
    CGFloat randomRed   = drand48();
    CGFloat randomGreen = drand48();
    CGFloat randomBlue  = drand48();
    
    return [UIColor colorWithRed:randomRed green:randomGreen blue:randomBlue alpha:1.0];
}


@end
