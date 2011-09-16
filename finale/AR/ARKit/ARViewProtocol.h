//
//  ARViewProtocol.h
//  ARKitDemo
//
//  Created by Niels Hansen on 9/12/11.
//  Copyright 2011 Agilite Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARGeoCoordinate.h"

@protocol ARViewProtocol <NSObject>
    -(void) locationClicked:(ARGeoCoordinate *) coordinate;
@end
