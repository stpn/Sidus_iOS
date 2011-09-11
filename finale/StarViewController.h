
#import <Three20/Three20.h>
#import "DBAuthenticatedTableViewController.h"
#import "Star.h"
#import <RestKit/Three20/Three20.h>

@interface StarViewController : DBAuthenticatedTableViewController <RKObjectLoaderDelegate> {
	UITextField* _starNameField;
    UITextField* _yCoordField;
    UITextField* _xCoordField;
    
  
	Star* _star;
    
    SLUser *_thisUser;
}

/**
 * The Topic that is being viewed
 */
@property (nonatomic, readonly) Star* star;

@property (nonatomic, readonly) SLUser* thisUser;


@end
