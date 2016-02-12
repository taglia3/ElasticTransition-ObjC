//
//  ElasticTransition.h
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#import "EdgePanTransition.h"

/*
typedef enum{
    NONE,
    ROTATE,
    TRANSLATEMID,
    TRANSLATEPULL,
    TRANSLATEPUSH
}ElasticTransitionBackgroundTransform;
 */

typedef NS_ENUM(int,ElasticTransitionBackgroundTransform){
    NONE,
    ROTATE,
    TRANSLATEMID,
    TRANSLATEPULL,
    TRANSLATEPUSH
};

@interface ElasticTransition : EdgePanTransition

@end
