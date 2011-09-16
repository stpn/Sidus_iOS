//
//  ARViewController.h
//  ARKitDemo
//
//  Created by Niels W Hansen on 1/23/10.
//  Copyright 2010 Agilite Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLocationDelegate.h"
#import "ARViewProtocol.h"


@class AugmentedRealityController;

@interface ARViewController : UIViewController<ARViewProtocol> {
	AugmentedRealityController	*agController;
	id<ARLocationDelegate> delegate;
    BOOL unloaded;
}

@property (nonatomic, retain) AugmentedRealityController *agController;
@property (nonatomic, assign) id<ARLocationDelegate> delegate;
@property (nonatomic) BOOL unloaded;

-(id)initWithDelegate:(id<ARLocationDelegate>) aDelegate;

-(void) unloadFromView;


@end

