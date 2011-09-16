//
//  ARKit.m
//  ARKitDemo
//
//  Created by Jared Crawford on 2/13/10.
//  Copyright 201. All rights reserved.
//

#import "ARKit.h"


@implementation ARKit

+(BOOL)deviceSupportsAR{
	
	//Detect camera, if not there, return NO
	if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		return NO;
	}
	
	if(![CLLocationManager headingAvailable]){
		return NO;
	}
		
	//cannot detect presence of GPS
	//I could look at location accuracy, but the GPS takes too long to
	//initialize to be effective for a quick check
	//I'll assume if you made it this far, it's there
	
	return YES;
}
@end
