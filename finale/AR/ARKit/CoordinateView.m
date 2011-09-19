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
#import "TouchDrawView.h"
#import <QuartzCore/QuartzCore.h>
#import "Line.h"


#define BOX_WIDTH 150
#define BOX_HEIGHT 100


#define BOX2_WIDTH 400
#define BOX2_HEIGHT 300

@implementation CoordinateView


@synthesize coordinateInfo;
@synthesize delegate;


- (id)initForCoordinate:(ARGeoCoordinate *)coordinate withDelgate:(id<ARViewProtocol>) aDelegate {
    
    
	[self setCoordinateInfo:coordinate];
    [self setDelegate:aDelegate];
    
    linesInProcess = [[NSMutableDictionary alloc] init];
    completeLines = [[NSMutableArray alloc] init];
    
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

		

        CGRect screenRect = [[UIScreen mainScreen] bounds];

        drawingView = [[TouchDrawView alloc]initWithFrame:screenRect];
        
        
        [drawingView setFrame:	CGRectMake((int)(BOX_WIDTH / 2.0 - [pointView image].size.width / 2.0), 
                                           (int)(BOX_HEIGHT / 2.0 - [pointView image].size.height / 2.0), 
                                           1500, 1500 )];        


	//	[self addSubview:titleLabel];
	//	[self addSubview:pointView];
		[self setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:drawingView];
        
        [drawingView release];
		[titleLabel release];
		[pointView release];
	}
	
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@ was touched!",[[self coordinateInfo] title]);
    [delegate locationClicked:[self coordinateInfo]];

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
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
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    //    CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
    CGContextFillRect(context, rect);
    
    CGContextTranslateCTM(context, 0.0f, 0.0f);
    
    // Draw complete Lines in black
    [[UIColor whiteColor] set];
    
    for (Line *line in completeLines) {
        
        
        // Add a star to the begining of the current path
        CGPoint beginStarCenter = CGPointMake([line begin].x, [line begin].y);
        CGContextMoveToPoint(context, beginStarCenter.x, beginStarCenter.y + 2.0);
        for(int i = 1; i < 11; ++i)
        {
            CGFloat x = 2.0 * sinf(i * 10.0 * M_PI / 11.0);
            CGFloat y = 2.0 * cosf(i * 10.0 * M_PI / 11.0);
            CGContextAddLineToPoint(context, beginStarCenter.x + x, beginStarCenter.y + y);
        }
        // And close the subpath.
        CGContextClosePath(context);
        
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        
        // Add a star to the end of the current path
        CGPoint endStarCenter = CGPointMake([line end].x, [line end].y);
        CGContextMoveToPoint(context, endStarCenter.x, endStarCenter.y + 2.0);
        for(int i = 1; i < 11; ++i)
        {
            CGFloat x = 2.0 * sinf(i * 10.0 * M_PI / 11.0);
            CGFloat y = 2.0 * cosf(i * 10.0 * M_PI / 11.0);
            CGContextAddLineToPoint(context, endStarCenter.x + x, endStarCenter.y + y);
        }
        // And close the subpath.

        
        CGContextClosePath(context);
        
        CGContextStrokePath(context);
        
        
    }
    
    [[UIColor redColor] set];
    for (NSValue *v in linesInProcess){
        
        Line *line = [linesInProcess objectForKey:v];
        
        // Add a star to the current path
        CGPoint center = CGPointMake([line begin].x, [line begin].y);
        CGContextMoveToPoint(context, center.x, center.y + 20.0);
        for(int i = 1; i < 11; ++i)
        {
            CGFloat x = 20.0 * sinf(i * 10.0 * M_PI / 11.0);
            CGFloat y = 20.0 * cosf(i * 10.0 * M_PI / 11.0);
            CGContextAddLineToPoint(context, center.x + x, center.y + y);
        }
        // And close the subpath.
        CGContextClosePath(context);
        
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    
    [super drawRect:rect];

}

- (void)dealloc {
    [super dealloc];
}



@end
