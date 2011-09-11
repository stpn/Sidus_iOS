//
//  Linkage.h
//  finale
//
//  Created by project on 9/9/11.
//  Copyright 2011 NYU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/CoreData/CoreData.h>
#import "StarContent.h"


@interface Linkage : StarContent {
    
    
    
@private
}

@property (nonatomic, readonly) NSString* linkNavURL;
@property (nonatomic, retain) NSNumber * startID;
@property (nonatomic, retain) NSNumber * endID;

@end
