//
//  MainViewController.m
//  TouchTracker
//
//  Created by Ezer Longinus on 9/5/11.
//  Copyright 2011 Limbic Systems. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "TouchDrawView.h"


@implementation MainViewController

@synthesize vImagePreview;


/* ///////////@Stepan:

EVERYTHING VIDEO HAPPENS IN viewDidAppear:(BOOL)animated 

TO GET THE AVFOUNDATION (e.g. videoinput) TO WORK YOU NEED TO ADD SEVERAL LIBRARIES TO THE PROJECTS (THEY ARE ALREADY ADDED HERE): CoreVideo; CoreMedia; AVFoundation; ImageIO 

 
RIGHT NOW I ADDED A VIEW IN INTERFACE BUILDER AND THE vImagePreview IS LINKED TO THAT VIEW.
 
*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

//@STEPAN: .title IS ADDED SO THAT Three20 COULD RECOGNIZE THE VIEW IN appDelegate [map...]
        
        self.title = @"Drawing";
        self.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle: @"*"
                                          style: UIBarButtonItemStyleBordered
                                         target: nil
                                         action: nil] autorelease];
    }

    
    return self;
    }


-(void) viewDidAppear:(BOOL)animated
{

    // Create the AVCapture Session
    
	AVCaptureSession *session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetMedium;
    

	CALayer *viewLayer = self.vImagePreview.layer;

	NSLog(@"viewLayer = %@", viewLayer);

    // create a preview layer to show the output from the camera

	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
	captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
	[self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
  
    

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
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    


    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
