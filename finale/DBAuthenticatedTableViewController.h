

#import <Three20/Three20.h>
#import "SLUser.h"
#import "DBLoginOrSignUpViewController.h"

@interface DBAuthenticatedTableViewController : TTTableViewController <DBLoginOrSignupViewControllerDelegate> {
	SLUser* _requiredUser;
}

/**
 * The User who we must be logged in as to edit the specified content
 */
@property (nonatomic, retain) SLUser* requiredUser;

/**
 * Presents the Login controller if the current User is not authenticated
 */
- (void)presentLoginViewControllerIfNecessary;

@end
