//
//  CustomSnapBehavior.m
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "CustomSnapBehavior.h"
#import "DynamicItem.h"
#import "PointExtension.h"

@interface CustomSnapBehavior ()

@property (nonatomic) UIAttachmentBehavior *ab1;
@property (nonatomic) UIAttachmentBehavior *ab2;
@property (nonatomic) UIAttachmentBehavior *ab3;
@property (nonatomic) UIAttachmentBehavior *ab4;

@property (nonatomic) id <UIDynamicItem> item;

@end


@implementation CustomSnapBehavior

@synthesize point, damping, frequency;
@synthesize ab1, ab2, ab3, ab4;

-(id)init{
    
    self = [super init];
    
    if(self){
        
        self.frequency = 1;
        self.damping = 0;
    }
    
    return self;
}

-(id)initWithItem:(id <UIDynamicItem>)item Point:(CGPoint)aPoint{
    
    self = [super init];
    
    if (self) {
        
        self.item = item;
        self.point =point;
        
        ab1 = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:aPoint];
        [self addChildBehavior:ab1];
        ab2 = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:aPoint];
        [self addChildBehavior:ab2];
        ab3 = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:aPoint];
        [self addChildBehavior:ab3];
        ab4 = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:aPoint];
        [self addChildBehavior:ab4];
        
        ab1.length = 50;
        ab2.length = 50;
        ab3.length = 50;
        ab4.length = 50;
        
        [self updatePoints];
        
    }
    
    return self;
}


- (void) setFrequency:(CGFloat)aFrequency{
    
    self->frequency = aFrequency;
    
    ab1.frequency = frequency;
    ab2.frequency = frequency;
    ab3.frequency = frequency;
    ab4.frequency = frequency;
}

- (void) setDamping:(CGFloat)aDamping{
    
     self->damping = aDamping;
    
    ab1.damping = damping;
    ab2.damping = damping;
    ab3.damping = damping;
    ab4.damping = damping;
}

-(void)setPoint:(CGPoint)aPoint{
    
    self->point =aPoint;
    
    [self updatePoints];
}

- (void)updatePoints{
    
    ab1.anchorPoint = CGPointTranslate(self.point, 50, 0);
    ab2.anchorPoint = CGPointTranslate(self.point, -50, 0);
    ab3.anchorPoint = CGPointTranslate(self.point, 0, 50);
    ab4.anchorPoint = CGPointTranslate(self.point, 0, -50);
}

@end
