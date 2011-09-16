//
//  GEOLocations.h
//  iPhoneAugmentedRealityLib
//
//  Created by Niels W Hansen on 12/19/09.
//  Copyright 2009 Agilite Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARLocationDelegate.h"
 
@class ARCoordinate;

@interface GEOLocations : NSObject {
	

	id<ARLocationDelegate> delegate;
}

@property(nonatomic,assign) id<ARLocationDelegate> delegate;

- (id)initWithDelegate:(id<ARLocationDelegate>) aDelegate;
-(NSMutableArray*) returnLocations;




@end
