//
//  MainView.h
//  TouchTracker
//
//  Created by Ezer Longinus on 9/6/11.
//  Copyright 2011 Limbic Systems. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainView : UIView {    
    NSMutableDictionary *linesInProcess;
    NSMutableArray *completeLines;
 
}


    
-(void)drawInContext:(CGContextRef)context;
    
@end