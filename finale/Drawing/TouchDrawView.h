//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Ezer Longinus on 9/5/11.
//  Copyright 2011 Limbic Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultStrokeColor         [UIColor whiteColor]
#define kDefaultRectColor           [UIColor whiteColor]
#define kDefaultStrokeWidth         1.0
#define kDefaultCornerRadius        30.0

@interface TouchDrawView : UIView {
    NSMutableDictionary *linesInProcess;
    NSMutableArray *completeLines;
    
    CGSize glowOffset;
    UIColor *glowColor;
    CGFloat glowRadius;
    
    UIColor     *strokeColor;
    UIColor     *rectColor;
    CGFloat     strokeWidth;
    CGFloat     cornerRadius;
}

@property(readwrite, retain, nonatomic) UIColor *glowColor;
@property(readwrite, nonatomic) CGSize glowOffset;
@property(readwrite, nonatomic) CGFloat glowRadius;
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *rectColor;
@property CGFloat strokeWidth;
@property CGFloat cornerRadius;

@end
