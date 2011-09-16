//
//  MainViewController.h
//  ARKitDemo
//
//  Created by Niels Hansen on 9/11/11.
//  Copyright 2011 Agilite Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARKit.h"

@interface ARRViewController : UIViewController<ARLocationDelegate> {
    ARViewController *cameraViewController;
    UIViewController *infoViewController;
}

-(IBAction) displayAR:(id) sender;

@property (nonatomic, retain) ARViewController *cameraViewController;
@property (nonatomic, retain) UIViewController *infoViewController;

@end
