//
//  MainViewController.m
//  ARKitDemo
//
//  Created by Niels Hansen on 9/11/11.
//  Copyright Agilite Software. All rights reserved.
//

#import "ARKitDemoAppDelegate.h"
#import "ARRViewController.h"

@implementation ARRViewController

@synthesize cameraViewController;
@synthesize infoViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
    }
    return self;
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

-(IBAction) displayAR:(id)sender {
    
 //   ARKitDemoAppDelegate *appDelegate = (ARKitDemoAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if([ARKit deviceSupportsAR]){
        [self setCameraViewController:[[ARViewController alloc] initWithDelegate:self]];
        [cameraViewController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
        [self presentModalViewController:cameraViewController animated:YES]; 
    }
    else {
        [self setInfoViewController:[[UIViewController alloc] init]];
        UILabel *errorLabel = [[UILabel alloc] init];
        [errorLabel setNumberOfLines:0];
        [errorLabel setText: @"Augmented Reality is not supported on this device"];
        [errorLabel setFrame: [[infoViewController view] bounds]];
        [errorLabel setTextAlignment:UITextAlignmentCenter];
        [[infoViewController view] addSubview:errorLabel];
        [errorLabel release];
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
        
        [closeButton setBackgroundColor:[UIColor blueColor]];
        [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [[infoViewController view] addSubview:closeButton];
        [closeButton release];
  //      [[appDelegate window] addSubview:[infoViewController view]];
 
    }
}

- (IBAction)closeButtonClicked:(id)sender {

    [[[self infoViewController] view] removeFromSuperview];
    infoViewController = nil;
}

-(void) locationClicked:(ARGeoCoordinate *) coordinate {
    
    if (coordinate != nil) {
        NSLog(@"Main View Controller received the click Event for: %@",[coordinate title]);
    //    [[self cameraViewController] setUnloaded:YES];
     //   [[self cameraViewController] unloadFromView];
     //   cameraViewController = nil;
        
        ARKitDemoAppDelegate *appDelegate = (ARKitDemoAppDelegate*)[[UIApplication sharedApplication] delegate];

        
        [self setInfoViewController:[[UIViewController alloc] init]];
        UILabel *errorLabel = [[UILabel alloc] init];
        [errorLabel setNumberOfLines:0];
        [errorLabel setText: [NSString stringWithFormat:@"You clicked on %@",[coordinate title]]];
        [errorLabel setFrame: [[infoViewController view] bounds]];
        [errorLabel setTextAlignment:UITextAlignmentCenter];
        [[infoViewController view] addSubview:errorLabel];
        [errorLabel release];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
        
        [closeButton setBackgroundColor:[UIColor blueColor]];
        [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [[infoViewController view] addSubview:closeButton];
        [closeButton release];
        
  //      [[appDelegate window] addSubview:[infoViewController view]];

    }
}


-(NSMutableArray*) geoLocations {
    
    NSMutableArray *locationArray = [[[NSMutableArray alloc] init] autorelease];
    ARGeoCoordinate *tempCoordinate;
    CLLocation        *tempLocation;
    
    tempLocation = [[CLLocation alloc] initWithLatitude:40.75590 longitude:-73.98322];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"EMPIRE STATE BUILDING"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:45.523875 longitude:-122.670399];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Portland"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:41.879535 longitude:-87.624333];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Chicago"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:30.268735 longitude:-97.745209];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Austin"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:51.500152 longitude:-0.126236];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"London"];
    tempCoordinate.inclination = M_PI/30;
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:48.856667 longitude:2.350987];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Paris"];
    tempCoordinate.inclination = M_PI/30;
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:55.676294 longitude:12.568116];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Copenhagen"];
    tempCoordinate.inclination = M_PI/30;
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:52.373801 longitude:4.890935];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Amsterdam"];
    tempCoordinate.inclination = M_PI/30;
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:19.611544 longitude:-155.665283];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Hawaii"];
    tempCoordinate.inclination = M_PI/30;
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:-40.900557 longitude:174.885971];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"New Zealand"];
    tempCoordinate.inclination = M_PI/40;
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:40.756054 longitude:-73.986951];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"New York City"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:42.35892 longitude:-71.05781];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Boston"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:49.817492 longitude:15.472962];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Czech Republic"];
    tempCoordinate.inclination = M_PI/30;
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:53.41291 longitude:-8.24389];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Ireland"];
    tempCoordinate.inclination = M_PI/30;
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:38.892091 longitude:-77.024055];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Washington, DC"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:45.545447 longitude:-73.639076];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Montreal"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    
    tempLocation = [[CLLocation alloc] initWithLatitude:32.78 longitude:-117.15];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"San Diego"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:-40.900557 longitude:174.885971];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Munich"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:33.5033333 longitude:-117.126611];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Temecula"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:19.26 longitude:-99.8];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Mexico City"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:53.566667 longitude:-113.516667];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Edmonton"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:47.620973 longitude:-122.347276];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Seattle"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    return locationArray;
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