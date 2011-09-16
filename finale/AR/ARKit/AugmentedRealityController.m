//
//  AugmentedRealityController.m
//  iPhoneAugmentedRealityLib
//
//  Modified by Niels W Hansen on 8/10/11.
//  Copyright 2011 Agilite Software. All rights reserved.
//

#import "AugmentedRealityController.h"
#import "ARCoordinate.h"
#import "ARGeoCoordinate.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

#define kFilteringFactor 0.05
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(x) ((x) * 180.0/M_PI)

@interface AugmentedRealityController (Private)
- (void) updateCenterCoordinate;
- (void) startListening;
- (double) findDeltaOfRadianCenter:(double*)centerAzimuth coordinateAzimuth:(double)pointAzimuth betweenNorth:(BOOL*) isBetweenNorth;
- (CGPoint) pointInView:(UIView *)realityView withView:(UIView *)viewToDraw forCoordinate:(ARCoordinate *)coordinate;
- (BOOL) viewportContainsView:(UIView *)viewToDraw forCoordinate:(ARCoordinate *)coordinate;
@end

@implementation AugmentedRealityController

@synthesize locationManager;
@synthesize accelerometerManager;
@synthesize displayView;
@synthesize centerCoordinate;
@synthesize scaleViewsBasedOnDistance;
@synthesize rotateViewsBasedOnPerspective;
@synthesize maximumScaleDistance;
@synthesize minimumScaleFactor;
@synthesize maximumRotationAngle;
@synthesize centerLocation;
@synthesize coordinates = coordinates;
@synthesize debugMode;
@synthesize currentOrientation;
@synthesize degreeRange;
@synthesize rootViewController;
@synthesize closeButton;
@synthesize debugView;
@synthesize latestHeading;
@synthesize viewAngle;
@synthesize coordinateViews;

@synthesize captureVideoPreviewLayer;


@synthesize cameraController;

- (id)initWithViewController:(ARViewController *)vc {
	coordinates		= [[NSMutableArray alloc] init];
	coordinateViews	= [[NSMutableArray alloc] init];
	latestHeading	= -1.0f;
	debugView		= nil;
	
	[self setRootViewController: vc];
    

	[self setDebugMode:NO];
	[self setMaximumScaleDistance: 0.0];
	[self setMinimumScaleFactor: 1.0];
	[self setScaleViewsBasedOnDistance: NO];
	[self setRotateViewsBasedOnPerspective: NO];
	[self setMaximumRotationAngle: M_PI / 6.0];
	
	CGRect screenRect = [[UIScreen mainScreen] bounds];

///MyVIEW:	
    
    
	[self setDisplayView: [[UIView alloc] initWithFrame: screenRect]];

    [self setCurrentOrientation:[[UIDevice currentDevice] orientation]];
    [self setCurrentOrientation:UIDeviceOrientationPortrait];
	[self setDegreeRange:[[self displayView] bounds].size.width / 12];

	[vc setView:displayView];
	
//	[self setCameraController: [[[UIImagePickerController alloc] init] autorelease]];
    
/////////// Create the AVCapture Session
    
	AVCaptureSession *session = [[AVCaptureSession alloc] init];
   
	session.sessionPreset = AVCaptureSessionPresetMedium;
	CALayer *viewLayer = self.displayView.layer;
	NSLog(@"viewLayer = %@", viewLayer);
    // create a preview layer to show the output from the camera
	captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
	captureVideoPreviewLayer.frame = self.displayView.bounds;
    
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    captureVideoPreviewLayer.orientation = [[UIDevice currentDevice] orientation];

    captureVideoPreviewLayer.automaticallyAdjustsMirroring = YES;
    
	[self.displayView.layer addSublayer:captureVideoPreviewLayer];
  	// Get the default camera device
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[session addInput:input];
	[session startRunning];


/*	
    [[self cameraController] setSourceType: UIImagePickerControllerSourceTypeCamera];
	[[self cameraController] setCameraViewTransform: CGAffineTransformScale([[self cameraController] cameraViewTransform], 1.13f,  1.13f)];
	[[self cameraController] setShowsCameraControls:NO];
	[[self cameraController] setNavigationBarHidden:YES];
	[[self cameraController] setCameraOverlayView:displayView];
*/	
	CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:37.41711 longitude:-122.02528];
	
	[self setCenterLocation: newCenter];
	[newCenter release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];	
    
    closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    
    [closeButton setBackgroundColor:[UIColor greenColor]];
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [displayView addSubview:closeButton];
    
    [closeButton release];
	
	[self startListening];
	
	return self;
}


// This is needed to start showing the Camera of the Augemented Reality Toolkit.
-(void) displayAR {
    @try {
//       [rootViewController presentModalViewController:self.avvViewController animated:NO];
       [displayView setFrame: [displayView bounds]]; 
    }
 	@catch (NSException *exception) {
        NSLog(@"displayAR exception: %@", exception);
    }
 	@finally {
        NSLog(@"No error");
    }
}

-(void) dismissAR {
    @try {
        [[[self rootViewController] parentViewController] dismissModalViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"Dismiss AR exception: %@", exception);
    }
    @finally {
        NSLog(@"No error dismissing");
    }
}

- (IBAction)closeButtonClicked:(id)sender {
    [[self rootViewController] setUnloaded:YES];
    [[self rootViewController] unloadFromView];
}



-(void) unloadCamera {
    [self stopListening];
    [self dismissAR];
}

- (void)startListening {
	
	// start our heading readings and our accelerometer readings.
	if (![self locationManager]) {
		[self setLocationManager: [[CLLocationManager alloc] init]];
		[[self locationManager] setHeadingFilter: kCLHeadingFilterNone];
		[[self locationManager] setDesiredAccuracy: kCLLocationAccuracyBest];
		[[self locationManager] startUpdatingHeading];
		[[self locationManager] startUpdatingLocation];
		[[self locationManager] setDelegate: self];
	}
			
	if (![self accelerometerManager]) {
		[self setAccelerometerManager: [UIAccelerometer sharedAccelerometer]];
		[[self accelerometerManager] setUpdateInterval: 0.25];
		[[self accelerometerManager] setDelegate: self];
	}
	
	if (![self centerCoordinate]) 
		[self setCenterCoordinate:[ARCoordinate coordinateWithRadialDistance:1.0 inclination:0 azimuth:0]];
}

- (void)stopListening {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   
    if ([self locationManager]) {
       [[self locationManager] setDelegate: nil];
    }
    
    if ([self accelerometerManager]) {
       [[self accelerometerManager] setDelegate: nil];
    }
}
  


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	latestHeading = degreesToRadian(newHeading.magneticHeading);
	[self updateCenterCoordinate];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
	return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if (oldLocation == nil)
		[self setCenterLocation:newLocation];
}


-(void) setupDebugPostion {
	
	if ([self debugMode]) {
		[debugView sizeToFit];
		CGRect displayRect = [[self displayView] bounds];
		
		[debugView setFrame:CGRectMake(0, displayRect.size.height - [debugView bounds].size.height,  displayRect.size.width, [debugView bounds].size.height)];
	}
}

- (void)updateCenterCoordinate {
	
	double adjustment = 0;
	
	if (currentOrientation == UIDeviceOrientationLandscapeLeft)
		adjustment = degreesToRadian(270); 
	else if (currentOrientation == UIDeviceOrientationLandscapeRight)
		adjustment = degreesToRadian(90);
	else if (currentOrientation == UIDeviceOrientationPortraitUpsideDown)
		adjustment = degreesToRadian(180);

	[[self centerCoordinate] setAzimuth: latestHeading - adjustment];
	[self updateLocations];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
	switch (currentOrientation) {
		case UIDeviceOrientationLandscapeLeft:
			viewAngle = atan2(acceleration.x, acceleration.z);
			break;
		case UIDeviceOrientationLandscapeRight:
			viewAngle = atan2(-acceleration.x, acceleration.z);
			break;
		case UIDeviceOrientationPortrait:
			viewAngle = atan2(acceleration.y, acceleration.z);
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			viewAngle = atan2(-acceleration.y, acceleration.z);
			break;	
		default:
			break;
	}
	
	[self updateCenterCoordinate];
}

- (void)setCenterLocation:(CLLocation *)newLocation {
	[centerLocation release];
	centerLocation = [newLocation retain];
	
	for (ARGeoCoordinate *geoLocation in [self coordinates]) {
		
		if ([geoLocation isKindOfClass:[ARGeoCoordinate class]]) {
			[geoLocation calibrateUsingOrigin:centerLocation];
			
			if ([geoLocation radialDistance] > [self maximumScaleDistance]) 
				[self setMaximumScaleDistance:[geoLocation radialDistance]];
		}
	}
}


- (void)addCoordinate:(ARCoordinate *)coordinate augmentedView:(UIView *)agView animated:(BOOL)animated {
	
	[coordinates addObject:coordinate];
	
	if ([coordinate radialDistance] > [self maximumScaleDistance]) 
		[self setMaximumScaleDistance: [coordinate radialDistance]];
	
	[coordinateViews addObject:agView];
}


- (void)removeCoordinate:(ARCoordinate *)coordinate {
	[self removeCoordinate:coordinate animated:YES];
}

- (void)removeCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated {
	[coordinates removeObject:coordinate];
}

- (void)removeCoordinates:(NSArray *)coordinateArray {	
	
	for (ARCoordinate *coordinateToRemove in coordinateArray) {
		NSUInteger indexToRemove = [coordinates indexOfObject:coordinateToRemove];
		
		//TODO: Error checking in here.
		[coordinates	 removeObjectAtIndex:indexToRemove];
		[coordinateViews removeObjectAtIndex:indexToRemove];
	}
}

-(double) findDeltaOfRadianCenter:(double*)centerAzimuth coordinateAzimuth:(double)pointAzimuth betweenNorth:(BOOL*) isBetweenNorth {

	if (*centerAzimuth < 0.0) 
		*centerAzimuth = (M_PI * 2.0) + *centerAzimuth;
	
	if (*centerAzimuth > (M_PI * 2.0)) 
		*centerAzimuth = *centerAzimuth - (M_PI * 2.0);
	
	double deltaAzimith = ABS(pointAzimuth - *centerAzimuth);
	*isBetweenNorth		= NO;

	// If values are on either side of the Azimuth of North we need to adjust it.  Only check the degree range
	if (*centerAzimuth < degreesToRadian([self degreeRange]) && pointAzimuth > degreesToRadian(360-[self degreeRange])) {
		deltaAzimith	= (*centerAzimuth + ((M_PI * 2.0) - pointAzimuth));
		*isBetweenNorth = YES;
	}
	else if (pointAzimuth < degreesToRadian([self degreeRange]) && *centerAzimuth > degreesToRadian(360-[self degreeRange])) {
		deltaAzimith	= (pointAzimuth + ((M_PI * 2.0) - *centerAzimuth));
		*isBetweenNorth = YES;
	}
			
	return deltaAzimith;
}

- (BOOL)viewportContainsView:(UIView *)viewToDraw  forCoordinate:(ARCoordinate *)coordinate {
	
	double currentAzimuth = [[self centerCoordinate] azimuth];
	double pointAzimuth	  = [coordinate azimuth];
	BOOL isBetweenNorth	  = NO;
	double deltaAzimith	  = [self findDeltaOfRadianCenter: &currentAzimuth coordinateAzimuth:pointAzimuth betweenNorth:&isBetweenNorth];
	BOOL result			  = NO;
	
	if (deltaAzimith <= degreesToRadian([self degreeRange]))
		result = YES;

	return result;
}

- (void)updateLocations {
	
	if (!coordinateViews || [coordinateViews count] == 0) 
		return;
	
	[debugView setText: [NSString stringWithFormat:@"%.3f %.3f ", -radianToDegrees(viewAngle), [[self centerCoordinate] azimuth]]];
	
	int index			= 0;
	int totalDisplayed	= 0;
	
	for (ARCoordinate *item in coordinates) {
		
		UIView *viewToDraw = [coordinateViews objectAtIndex:index];
		
		if ([self viewportContainsView:viewToDraw forCoordinate:item]) {
			
			CGPoint loc = [self pointInView:[self displayView] withView:viewToDraw forCoordinate:item];
			CGFloat scaleFactor = 1.0;
	
			if ([self scaleViewsBasedOnDistance]) 
				scaleFactor = 1.0 - [self minimumScaleFactor] * ([item radialDistance] / [self maximumScaleDistance]);
			
			float width	 = [viewToDraw bounds].size.width  * scaleFactor;
			float height = [viewToDraw bounds].size.height * scaleFactor;
			
			[viewToDraw setFrame:CGRectMake(loc.x - width / 2.0, loc.y - (height / 2.0), width, height)];
            
			totalDisplayed++;
			
			CATransform3D transform = CATransform3DIdentity;
			
			// Set the scale if it needs it. Scale the perspective transform if we have one.
			if ([self scaleViewsBasedOnDistance]) 
				transform = CATransform3DScale(transform, scaleFactor, scaleFactor, scaleFactor);
			
			if ([self rotateViewsBasedOnPerspective]) {
				transform.m34 = 1.0 / 300.0;
				
				double itemAzimuth		= [item azimuth];
				double centerAzimuth	= [[self centerCoordinate] azimuth];
				
				if (itemAzimuth - centerAzimuth > M_PI) 
					centerAzimuth += 2 * M_PI;
				
				if (itemAzimuth - centerAzimuth < -M_PI) 
					itemAzimuth  += 2 * M_PI;
				
				double angleDifference	= itemAzimuth - centerAzimuth;
				transform				= CATransform3DRotate(transform, [self maximumRotationAngle] * angleDifference / 0.3696f , 0, 1, 0);
			}
			
			[[viewToDraw layer] setTransform:transform];
			
			//if we don't have a superview, set it up.
			if (!([viewToDraw superview])) {
				[[self displayView] addSubview:viewToDraw];
				[[self displayView] sendSubviewToBack:viewToDraw];
			}
		} 
		else 
			[viewToDraw removeFromSuperview];
		
		index++;
	}
}

- (CGPoint)pointInView:(UIView *)realityView withView:(UIView *)viewToDraw forCoordinate:(ARCoordinate *)coordinate {	
	
	CGPoint point;
	CGRect realityBounds	= [realityView bounds];
	double currentAzimuth	= [[self centerCoordinate] azimuth];
	double pointAzimuth		= [coordinate azimuth];
	BOOL isBetweenNorth		= NO;
	double deltaAzimith		= [self findDeltaOfRadianCenter: &currentAzimuth coordinateAzimuth:pointAzimuth betweenNorth:&isBetweenNorth];
	
	if ((pointAzimuth > currentAzimuth && !isBetweenNorth) || (currentAzimuth > degreesToRadian(360-[self degreeRange]) && pointAzimuth < degreesToRadian([self degreeRange])))
		point.x = (realityBounds.size.width / 2) + ((deltaAzimith / degreesToRadian(1)) * 12);  // Right side of Azimuth
	else
		point.x = (realityBounds.size.width / 2) - ((deltaAzimith / degreesToRadian(1)) * 12);	// Left side of Azimuth
	
	point.y = (realityBounds.size.height / 2) + (radianToDegrees(M_PI_2 + viewAngle)  * 2.0);
	
	return point;
}

-(NSComparisonResult) LocationSortClosestFirst:(ARCoordinate *) s1 secondCoord:(ARCoordinate*) s2 {
    
	if ([s1 radialDistance] < [s2 radialDistance]) 
		return NSOrderedAscending;
	else if ([s1 radialDistance] > [s2 radialDistance]) 
		return NSOrderedDescending;
	else 
		return NSOrderedSame;
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
	
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	// Later we may handle the Orientation of Faceup to show a Map.  For now let's ignore it.
	if (orientation != UIDeviceOrientationUnknown && orientation != UIDeviceOrientationFaceUp && orientation != UIDeviceOrientationFaceDown) {
		
		CGAffineTransform transform = CGAffineTransformMakeRotation(degreesToRadian(0));
		CGRect bounds = [[UIScreen mainScreen] bounds];
		
		if (orientation == UIDeviceOrientationLandscapeLeft) {
			transform		   = CGAffineTransformMakeRotation(degreesToRadian(90));
			bounds.size.width  = [[UIScreen mainScreen] bounds].size.height;
			bounds.size.height = [[UIScreen mainScreen] bounds].size.width;
		}
		else if (orientation == UIDeviceOrientationLandscapeRight) {
			transform		   = CGAffineTransformMakeRotation(degreesToRadian(-90));
			bounds.size.width  = [[UIScreen mainScreen] bounds].size.height;
			bounds.size.height = [[UIScreen mainScreen] bounds].size.width;
		}
		else if (orientation == UIDeviceOrientationPortraitUpsideDown)
			transform = CGAffineTransformMakeRotation(degreesToRadian(180));
		
		[displayView setTransform:CGAffineTransformIdentity];
		[displayView setTransform: transform];
		[displayView setBounds:bounds];
		
		[self setDegreeRange:[[self displayView] bounds].size.width / 12];
		[self setDebugMode:YES];
	}
}


- (void)setDebugMode:(BOOL)flag {

	if ([self debugMode] == flag) {
		currentOrientation = [[UIDevice currentDevice] orientation];

		CGRect debugRect  = CGRectMake(0, [[self displayView] bounds].size.height -20, [[self displayView] bounds].size.width, 20);	
		[debugView setFrame: debugRect];
		return;
	}
	
	debugMode = flag;
	
	if ([self debugMode]) {
		debugView = [[UILabel alloc] initWithFrame:CGRectZero];
		[debugView setTextAlignment: UITextAlignmentCenter];
		[debugView setText: @"Waiting..."];
		[displayView addSubview:debugView];
		[self setupDebugPostion];
	}
	else 
		[debugView removeFromSuperview];
}

- (void)dealloc {
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	[locationManager release];
	[coordinateViews release];
	[coordinates release];
	[debugView release];
    [super dealloc];
}


@end
