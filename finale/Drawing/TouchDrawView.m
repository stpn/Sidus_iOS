//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Ezer Longinus on 9/5/11.
//  Copyright 2011 Limbic Systems. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"
#import <QuartzCore/QuartzCore.h>


@implementation TouchDrawView

@synthesize glowColor;
@synthesize glowRadius;
@synthesize glowOffset;

- (id)initWithCoder:(NSCoder *) c
{
    [super initWithCoder:c];
    linesInProcess = [[NSMutableDictionary alloc] init];
    completeLines = [[NSMutableArray alloc] init];
    [self setMultipleTouchEnabled:YES];
    
    glowOffset = CGSizeMake(0.0f, 0.0f);
    glowColor = [UIColor colorWithRed:(62.0/255.0) green:(136.0/255.0) blue:(255.0/255.0) alpha:1.0f];
    glowRadius = 200.0f;
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
    CGContextFillRect(context, rect);
    
   
    

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
        CGContextSetShadowWithColor(context, glowOffset, glowRadius, [UIColor colorWithRed:(62.0/255.0) green:(136.0/255.0) blue:(255.0/255.0) alpha:1.0f].CGColor);

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
    [glowColor release];
    [linesInProcess release];
    [completeLines  release];
    [super dealloc];
}

@end
