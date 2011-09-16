//
//  ARViewController.m
//  ARKitDemo
//
//  Created by Niels W Hansen on 1/23/10.
//  Copyright 2011 Agilite Software. All rights reserved.
//

#import "ARViewController.h"
#import "AugmentedRealityController.h"
#import "GEOLocations.h"
#import "CoordinateView.h"

@implementation ARViewController

@synthesize agController;
@synthesize delegate;
@synthesize unloaded;

-(id)initWithDelegate:(id<ARLocationDelegate>) aDelegate {
	
	[self setDelegate:aDelegate];
	
	if (!(self = [super init]))
		return nil;
	
	[self setWantsFullScreenLayout: YES];
    
 	return self;
}

- (void)loadView {
    
	[self setAgController:[[AugmentedRealityController alloc] initWithViewController:self]];
	
	[agController setDebugMode:NO];
	[agController setScaleViewsBasedOnDistance:YES];
	[agController setMinimumScaleFactor:0.5];
	[agController setRotateViewsBasedOnPerspective:YES];
	
	GEOLocations* locations = [[GEOLocations alloc] initWithDelegate:delegate];
	
	if ([[locations returnLocations] count] > 0) {
		for (ARGeoCoordinate *coordinate in [locations returnLocations]) {
			CoordinateView *cv = [[CoordinateView alloc] initForCoordinate:coordinate withDelgate:self] ;
			[agController addCoordinate:coordinate augmentedView:cv animated:NO];
			[cv release];
		}
	}
	
	[locations release];
    
    unloaded = NO;

}

-(void) unloadFromView {
    unloaded = YES;
    [agController unloadCamera];
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	
	if (agController && unloaded == NO)
        [agController displayAR];
    
	[super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

-(void) locationClicked:(ARGeoCoordinate *) coordinate {
    NSLog(@"delegate worked click on %@", [coordinate title]);
    [delegate locationClicked:coordinate];
    
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [agController release];
	agController = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
