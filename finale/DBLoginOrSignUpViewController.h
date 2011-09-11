

#import <Three20/Three20.h>
#import <Three20/Three20+Additions.h>
#import <RestKit/RestKit.h>
#import "SLUser.h"

@protocol DBLoginOrSignupViewControllerDelegate;


@interface DBLoginOrSignUpViewController : TTTableViewController <UITextFieldDelegate, SLUserAuthenticationDelegate> {
	UIBarButtonItem* _signupOrLoginButtonItem;
	BOOL _showingSignup;

	UITextField* _usernameField;
	UITextField* _passwordField;
	UITextField* _passwordConfirmationField;
	UITextField* _emailField;
	
	id<DBLoginOrSignupViewControllerDelegate> _delegate;
}

@property (nonatomic, assign) id<DBLoginOrSignupViewControllerDelegate> delegate;


@end

@protocol DBLoginOrSignupViewControllerDelegate

- (void)loginControllerDidCancel:(DBLoginOrSignUpViewController*)loginController;

@end
