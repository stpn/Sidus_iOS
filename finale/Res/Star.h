//
//  Star.h
//  finale
//
//  Created by Zzbg on 8/29/11.
//  Copyright (c) 2011 NYU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/CoreData/CoreData.h>
#import "StarContent.h"


@interface Star : StarContent {



@private
}

@property (nonatomic, readonly) NSString* starNavURL;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSNumber * starID;
@property (nonatomic, retain) NSNumber * XCoord;
@property (nonatomic, retain) NSNumber * YCoord;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * name;

@end
