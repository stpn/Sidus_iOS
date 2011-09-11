//
//  Linkage.m
//  finale
//
//  Created by project on 9/9/11.
//  Copyright 2011 NYU. All rights reserved.
//

#import "Linkage.h"


@implementation Linkage
@dynamic startID;
@dynamic endID;



- (NSString*)linkNavURL {
    return RKMakePathWithObject(@"tt://linkages/(linkID)", self);
}

- (BOOL)isNewRecord {
	return [self.startID intValue] == 0;
}

@end
