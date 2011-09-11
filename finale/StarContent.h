//
//  StarContent.h
//  finale
//
//  Created by project on 9/8/11.
//  Copyright 2011 NYU. All rights reserved.
//
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>
// Posted when a content object has changed
extern NSString* const StarContentObjectDidChangeNotification;

/**
 * Abstract superclass for content models in the Discussion Board. Provides
 * common property & method definitions for the system
 */
@interface StarContent : NSManagedObject {
    
}
- (BOOL)isNewRecord;

@end
