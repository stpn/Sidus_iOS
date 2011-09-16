//
//  GEOLocations.m
//  iPhoneAugmentedRealityLib
//
//  Created by Niels W Hansen on 12/19/09.
//  Copyright 2009 Zac White. All rights reserved.
//

#import "GEOLocations.h"
#import "ARGeoCoordinate.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@implementation GEOLocations


@synthesize delegate;

- (id)initWithDelegate:(id<ARLocationDelegate>) aDelegate{
	[self setDelegate:aDelegate];

	return self;
}

-(NSMutableArray*) returnLocations 
{
	return [delegate geoLocations];
}

- (void)dealloc {
	

    [super dealloc];
}



@end
