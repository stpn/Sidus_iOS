//
//  CoordinateView.m
//  iPhoneAugmentedRealityLib
//
//  Created by Niels W Hansen on 12/19/09.
//  Copyright 2011 Agilite Software. All rights reserved.
//

#import "ARViewProtocol.h"
#import "ARGeoCoordinate.h"
#import "CoordinateView.h"


#define BOX_WIDTH 150
#define BOX_HEIGHT 100

@implementation CoordinateView


@synthesize coordinateInfo;
@synthesize delegate;

- (id)initForCoordinate:(ARGeoCoordinate *)coordinate withDelgate:(id<ARViewProtocol>) aDelegate {
    
	[self setCoordinateInfo:coordinate];
    [self setDelegate:aDelegate];
    
	CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	
	if ((self = [super initWithFrame:theFrame])) {
        
        [self setUserInteractionEnabled:YES]; // Allow for touches
        
		UILabel *titleLabel	= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BOX_WIDTH, 20.0)];
		
		[titleLabel setBackgroundColor: [UIColor colorWithWhite:.3 alpha:.8]];
		[titleLabel setTextColor:		[UIColor whiteColor]];
		[titleLabel setTextAlignment:	UITextAlignmentCenter];
		[titleLabel setText:			[coordinate title]];
		[titleLabel sizeToFit];

        
		[titleLabel setFrame: CGRectMake(BOX_WIDTH / 2.0 - [titleLabel bounds].size.width / 2.0 - 4.0, 0, 
                                         [titleLabel bounds].size.width + 8.0, [titleLabel bounds].size.height + 8.0)];
		
		UIImageView *pointView	= [[UIImageView alloc] initWithFrame:CGRectZero];
		[pointView setImage:[UIImage imageNamed:@"location.png"]];
        
		[pointView setFrame:	CGRectMake((int)(BOX_WIDTH / 2.0 - [pointView image].size.width / 2.0), 
                                           (int)(BOX_HEIGHT / 2.0 - [pointView image].size.height / 2.0), 
                                           [pointView image].size.width, [pointView image].size.height)];
		
		[self addSubview:titleLabel];
		[self addSubview:pointView];
		[self setBackgroundColor:[UIColor clearColor]];
        
		[titleLabel release];
		[pointView release];
	}
	
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@ was touched!",[[self coordinateInfo] title]);
    [delegate locationClicked:[self coordinateInfo]];

}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
    
    if(CGRectContainsPoint(theFrame, point))
        return YES; // touched the view;
    
    return NO;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
    [super dealloc];
}



@end
