//
//  StarContent.m
//  finale
//
//  Created by project on 9/8/11.
//  Copyright 2011 NYU. All rights reserved.
//

#import "StarContent.h"

NSString* const StarContentObjectDidChangeNotification = @"StarContentObjectDidChangeNotification";

@implementation StarContent

- (BOOL)isNewRecord {
    [self doesNotRecognizeSelector:_cmd];
	return NO;
}

@end