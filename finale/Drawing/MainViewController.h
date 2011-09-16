//
//  MainViewController.h
//  TouchTracker
//
//  Created by Ezer Longinus on 9/5/11.
//  Copyright 2011 Limbic Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"
#import "TouchDrawView.h"
#import <Three20/Three20.h>
#import <AVFoundation/AVFoundation.h>


@interface MainViewController : UIViewController {
    UIWindow *startWindow;
    MainView *startView;
    TouchDrawView *touchView;
    
    UIAccelerationValue	*accel;

    
}

@property(nonatomic, retain) IBOutlet UIView *vImagePreview;


@property (nonatomic) UIAccelerationValue *accel;


@end
