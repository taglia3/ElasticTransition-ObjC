//
//  PointExtension.h
//  ElasticTransistionExample
//
//  Created by Tigielle on 11/02/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

#ifndef PointExtension_h
#define PointExtension_h


CG_INLINE CGPoint
CGPointTranslate(CGPoint p, CGFloat dx, CGFloat dy) {
    return CGPointMake(p.x+dx, p.y+dy);
}

CG_INLINE CGPoint
CGPointTransform(CGPoint p, CGAffineTransform t) {
    return CGPointApplyAffineTransform(p, t);
}

CG_INLINE CGFloat
CGPointDistance(CGPoint p, CGPoint b) {
    return sqrt(pow(p.x-b.x,2)+pow(p.y-b.y,2));
}

#endif
