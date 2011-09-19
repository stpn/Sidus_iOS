//
//  CoordinateView.h
//  iPhoneAugmentedRealityLib
//
//  Created by Niels W Hansen on 12/19/09.
//  Copyright 2011 Agilite Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARViewProtocol.h"

@class TouchDrawView;
@class ARGeoCoordinate;

@interface CoordinateView : UIView {
    
    NSMutableDictionary *linesInProcess;
    NSMutableArray *completeLines;
    
    ARGeoCoordinate *coordinateInfo;
    id<ARViewProtocol> delegate;
    TouchDrawView *touchDrawView;
    
    
    TouchDrawView       *drawingView;

}

- (id)initForCoordinate:(ARGeoCoordinate *)coordinate withDelgate:(id<ARViewProtocol>) aDelegate;

@property (nonatomic,retain) ARGeoCoordinate *coordinateInfo;
@property (nonatomic, assign) id<ARViewProtocol> delegate;

@end
