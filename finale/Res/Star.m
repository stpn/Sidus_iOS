//
//  Star.m
//  finale
//
//  Created by Zzbg on 8/29/11.
//  Copyright (c) 2011 NYU. All rights reserved.
//

#import "Star.h"


@implementation Star
@dynamic userID;
@dynamic starID;
@dynamic XCoord;
@dynamic YCoord;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic name;



- (NSString*)starNavURL {
    return RKMakePathWithObject(@"tt://stars/(starID)", self);
}

- (BOOL)isNewRecord {
	return [self.starID intValue] == 0;
}

@end
