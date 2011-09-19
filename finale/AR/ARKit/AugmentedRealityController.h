//
//  AugmentedRealityController.h
//  iPhoneAugmentedRealityLib
//
//  Created by Niels W Hansen on 12/20/09.
//  Copyright 2011 Agilite Software All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ARViewController.h"
#import <UIKit/UIKit.h>

#import "TouchDrawView.h"

@class ARCoordinate;

@interface AugmentedRealityController : NSObject <UIAccelerometerDelegate, CLLocationManagerDelegate> {
    
	BOOL scaleViewsBasedOnDistance;
	BOOL rotateViewsBasedOnPerspective;
	
	double maximumScaleDistance;
	double minimumScaleFactor;
	double maximumRotationAngle;
	
	ARCoordinate		*centerCoordinate;
	CLLocationManager	*locationManager;
	UIDeviceOrientation currentOrientation;
	
	ARViewController	*rootViewController;
	UIAccelerometer		*accelerometerManager;
	CLLocation			*centerLocation;
	UIView				*displayView;
	UILabel				*debugView;
    UIButton            *closeButton;
	UIImagePickerController	*cameraController;
    
    TouchDrawView *touchDrawView;
    
@private
	double				latestHeading;
	double				degreeRange;
	float				viewAngle;
	BOOL				debugMode;
	
	NSMutableArray		*coordinates;
	NSMutableArray		*coordinateViews;
}

@property BOOL scaleViewsBasedOnDistance;
@property BOOL rotateViewsBasedOnPerspective;
@property BOOL debugMode;

@property double maximumScaleDistance;
@property double minimumScaleFactor;
@property double maximumRotationAngle;
@property double degreeRange;

@property (nonatomic, retain) UIAccelerometer	*accelerometerManager;
@property (nonatomic, retain) CLLocationManager	*locationManager;
@property (nonatomic, retain) ARCoordinate		*centerCoordinate;
@property (nonatomic, retain) CLLocation		*centerLocation;
@property (nonatomic, retain) UIView			*displayView;
@property (nonatomic, retain) ARViewController	*rootViewController;
@property (nonatomic, retain) UIImagePickerController *cameraController;
@property UIDeviceOrientation	currentOrientation;
@property (readonly) NSArray *coordinates;

- (id)initWithViewController:(UIViewController *)theView;

- (void) setupDebugPostion;
- (void) updateLocations;
- (void) displayAR;
- (void) dismissAR;
- (void) stopListening;
- (void) unloadCamera;

// Adding coordinates to the underlying data model.
- (void)addCoordinate:(ARCoordinate *)coordinate augmentedView:(UIView *)agView animated:(BOOL)animated ;

// Removing coordinates
- (void)removeCoordinate:(ARCoordinate *)coordinate;
- (void)removeCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated;
- (void)removeCoordinates:(NSArray *)coordinateArray;

@property (retain) UILabel              *debugView;
@property (retain) UIButton             *closeButton;
@property double                        latestHeading;
@property float                         viewAngle;
@property (retain) NSMutableArray		*coordinateViews;
@end
