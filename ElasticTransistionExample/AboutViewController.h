//
//  AboutViewController.h
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElasticTransition.h"

@interface AboutViewController : UIViewController

@property (nonatomic) ElasticTransition *transition;

-(IBAction)dismiss:(id)sender;

@end


