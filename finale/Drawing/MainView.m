//
//  MainView.m
//  TouchTracker
//
//  Created by Ezer Longinus on 9/6/11.
//  Copyright 2011 Limbic Systems. All rights reserved.
//

#import "MainView.h"
#import "Line.h"


@implementation MainView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if(self != nil)
	{
		self.backgroundColor = [UIColor blackColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
        linesInProcess = [[NSMutableDictionary alloc]init];
        completeLines = [[NSMutableArray alloc]init];
        [self setMultipleTouchEnabled:YES];

        
	}
    return self;
}

-(void)drawInContext:(CGContextRef)context
{
        
    
    
    
    //    CGRect ourRect = {{0.0, 0.0}, {130.0, 100.0}};
    //    int i, numRects = 6;
    //    float rotateAngle = 2*M_PI/numRects;
    //    float tint, tintAdjust = 1.0/numRects;
    //    // ***** Part 2 *****
    //    CGContextTranslateCTM (context, ourRect.size.width,
    //                           2*ourRect.size.height);
    //    // ***** Part 3 *****
    //    for(i = 0, tint = 1.0; i < numRects ; i++, tint -= tintAdjust){
    //        CGContextSetRGBFillColor (context, tint, 0.0, 0.0, tint);
    //        CGContextFillRect(context, ourRect);
    //         CGContextSetShadowWithColor(context, glowOffset, glowRadius, [UIColor colorWithRed:(62.0/255.0) green:(136.0/255.0) blue:(255.0/255.0) alpha:0.75f].CGColor);
    //        CGContextRotateCTM(context, rotateAngle); // cumulative
    //    }
    
}

-(void)drawRect:(CGRect)rect
{
	// Since we use the CGContextRef a lot, it is convienient for our demonstration classes to do the real work
	// inside of a method that passes the context as a parameter, rather than having to query the context
	// continuously, or setup that parameter for every subclass.
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)clearAll
{
    // Clear the containers
    [linesInProcess removeAllObjects];
    [completeLines removeAllObjects];
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches){
        
        // Is this a double tap?
        if([t tapCount] > 1){
            [self clearAll];
            return;
        }
        
        // Use the touch object (packed in an NSValue) as the key
        NSValue *key = [NSValue valueWithPointer:t];
        
        // Create a line for the value
        CGPoint loc = [t locationInView:self];
        Line *newLine = [[Line alloc] init];
        [newLine setBegin:loc];
        [newLine setEnd:loc];
        
        // Put pair in dictionary
        [linesInProcess setObject:newLine forKey:key];
        [newLine release];
        
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Update linesInProcess with moved touches
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithPointer:t];
        
        // Find the line for this touch
        Line *line = [linesInProcess objectForKey:key];
        
        // Update the line
        CGPoint loc = [t locationInView:self];
        [line setEnd: loc];
    }
    // Redraw
    
    [self setNeedsDisplay];
}

- (void)endTouches: (NSSet *) touches
{
    // Remove ending touches from dictionary
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithPointer:t];
        Line *line = [linesInProcess objectForKey:key];
        
        // If this is a double tap, 'line' will be nil
        if(line) {
            [completeLines addObject: line];
            [linesInProcess removeObjectForKey:key];
        }
    }
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

- (void)dealloc
{
    [linesInProcess release];
    [completeLines  release];
    [super dealloc];
}

@end