//
//  Line.h
//  TouchTracker
//
//  Created by Ezer Longinus on 9/5/11.
//  Copyright 2011 Limbic Systems. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Line : NSObject {
    CGPoint begin;
    CGPoint end;
}

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;

@end
