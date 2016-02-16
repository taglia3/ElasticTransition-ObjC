//
//  SwitchCellModel.m
//  ElasticTransitionExample
//
//  Created by Tigielle on 16/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "SwitchCellModel.h"

@implementation SwitchCellModel

@synthesize type, rowHeigth;
@synthesize name;


- (void)setSwitchOn:(BOOL)on{
    
    self.on = on;
    
    id<CellStateChange> strongDelegate = self.delegate;
    
    if([strongDelegate respondsToSelector:@selector(didChangeStateToOn:AndPropertyRelated:)]){
        
        [strongDelegate didChangeStateToOn:on AndPropertyRelated:self.type];
    }
}

@end
