

#import "DBAuthenticatedTableViewController.h"
#import "SLUser.h"

@implementation DBAuthenticatedTableViewController

@synthesize requiredUser = _requiredUser;

- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SLUserDidLoginNotification object:nil];
}

- (void)presentLoginViewControllerIfNecessary {
	if (NO == [[SLUser currentUser] isLoggedIn]) {
		// Register for login succeeded notification. populate view.
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:SLUserDidLoginNotification object:nil];
		
		DBLoginOrSignUpViewController* loginViewController = (DBLoginOrSignUpViewController*) TTOpenURL(@"tt://login");
		loginViewController.delegate = self;
	}
}

- (void)userDidLogin:(NSNotification*)note {
	// Check to ensure the User who logged in is allowed to access this controller.
	if ([[SLUser currentUser] isEqual:self.requiredUser]) {
		[self invalidateModel];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)loginControllerDidCancel:(DBLoginOrSignUpViewController*)loginController {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
