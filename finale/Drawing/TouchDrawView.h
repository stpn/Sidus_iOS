//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Ezer Longinus on 9/5/11.
//  Copyright 2011 Limbic Systems. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TouchDrawView : UIView {
    NSMutableDictionary *linesInProcess;
    NSMutableArray *completeLines;
    
    CGSize glowOffset;
    UIColor *glowColor;
    CGFloat glowRadius;
}

@property(readwrite, retain, nonatomic) UIColor *glowColor;
@property(readwrite, nonatomic) CGSize glowOffset;
@property(readwrite, nonatomic) CGFloat glowRadius;

@end
