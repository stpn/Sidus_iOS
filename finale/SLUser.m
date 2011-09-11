//
//  SLUser.m
//  DiscussionBoard
//
//  Created by Jeremy Ellison on 1/10/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "SLUser.h"
//#import "DBContentObject.h"

// Constants
static NSString* const kSLUserCurrentUserIDDefaultsKey = @"kSLUserCurrentUserIDDefaultsKey";

// Notifications
NSString* const SLUserDidLoginNotification = @"SLUserDidLoginNotification";
NSString* const SLUserDidFailLoginNotification = @"SLUserDidFailLoginNotification";
NSString* const SLUserDidLogoutNotification = @"SLUserDidLogoutNotification";

// Current User singleton
static SLUser* currentUser = nil;

@implementation SLUser

@dynamic email;
@dynamic username;
@dynamic singleAccessToken;
@dynamic userID;
@synthesize password = _password;
@synthesize passwordConfirmation = _passwordConfirmation;
@synthesize delegate = _delegate;

/**
 * Informs RestKit which property contains the primary key for identifying
 * this object. This is used to ensure that existing objects are updated during mapping
 */
+ (NSString*)primaryKeyProperty {
	return @"userID";
}

/**
 * Returns the singleton current User instance. There is always a User returned so that you
 * are not sending messages to nil
 */
+ (SLUser*)currentUser {
	if (nil == currentUser) {
		id userID = [[NSUserDefaults standardUserDefaults] objectForKey:kSLUserCurrentUserIDDefaultsKey];
		if (userID) {
			currentUser = [self findFirstByAttribute:@"userID" withValue:userID];
		} else {
			currentUser = [self object];
		}
		
		[currentUser retain];
	}
	
	return currentUser;
}

+ (void)setCurrentUser:(SLUser*)user {
	[user retain];
	[currentUser release];
	currentUser = user;
}

/**
 * Implementation of a RESTful sign-up pattern. We are just relying on RestKit for
 * request/response processing and object mapping, but we have built a higher level
 * abstraction around Sign-Up as a concept and exposed notifications and delegate
 * methods that make it much more meaningful than a POST/parse/process cycle would be.
 */
- (void)signUpWithDelegate:(NSObject<SLUserAuthenticationDelegate>*)delegate {
	_delegate = delegate;
	[[RKObjectManager sharedManager] postObject:self delegate:self];
}

/**
 * Implementation of a RESTful login pattern. We construct an object loader addressed to
 * the /login resource path and POST the credentials. The target of the object loader is
 * set so that the login response gets mapped back into this object, populating the
 * properties according to the mappings declared in elementToPropertyMappings.
 */
- (void)loginWithUsername:(NSString*)username andPassword:(NSString*)password delegate:(NSObject<SLUserAuthenticationDelegate>*)delegate {
	_delegate = delegate;
    self.username = username;
    self.password = password;
	
    [[RKObjectManager sharedManager] postObject:self delegate:self block:^(RKObjectLoader* loader) {
        loader.resourcePath = @"/login";
        loader.serializationMapping = [RKObjectMapping serializationMappingWithBlock:^(RKObjectMapping* mapping) {
            mapping.rootKeyPath = @"user_session";
            [mapping mapAttributes:@"username", @"password", nil];            
        }];
    }];
}

/**
 * Implementation of a RESTful logout pattern. We POST an object loader to
 * the /logout resource path. This destroys the remote session
 */
- (void)logout {
    [[RKObjectManager sharedManager] postObject:self delegate:self block:^(RKObjectLoader* loader) {
        loader.resourcePath = @"/logout";
    }];
}

- (void)loginWasSuccessful {
	// Upon login, we become the current user
	[SLUser setCurrentUser:self];
	
	// Persist the UserID for recovery later
	[[NSUserDefaults standardUserDefaults] setObject:self.userID forKey:kSLUserCurrentUserIDDefaultsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	// Inform the delegate
	if ([self.delegate respondsToSelector:@selector(userDidLogin:)]) {
		[self.delegate userDidLogin:self];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SLUserDidLoginNotification object:self];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray *)objects {
	// NOTE: We don't need objects because self is the target of the mapping operation
	
	if ([objectLoader wasSentToResourcePath:@"/login"]) {
		// Login was successful
		[self loginWasSuccessful];
	} else if ([objectLoader wasSentToResourcePath:@"/signup"]) { 
		// Sign Up was successful
		if ([self.delegate respondsToSelector:@selector(userDidSignUp:)]) {
			[self.delegate userDidSignUp:self];
		}
		
		// Complete the login as well
		[self loginWasSuccessful];		
	} else if ([objectLoader wasSentToResourcePath:@"/logout"]) {
		// Logout was successful
        
		// Clear the stored credentials
		[[NSUserDefaults standardUserDefaults] setValue:nil forKey:kSLUserCurrentUserIDDefaultsKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
		// Inform the delegate
		if ([self.delegate respondsToSelector:@selector(userDidLogout:)]) {
			[self.delegate userDidLogout:self];
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:SLUserDidLogoutNotification object:nil];
	}
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError*)error {	
	if ([objectLoader wasSentToResourcePath:@"/login"]) {
		// Login failed
		if ([self.delegate respondsToSelector:@selector(user:didFailLoginWithError:)]) {
			[self.delegate user:self didFailLoginWithError:error];
		}
	} else if ([objectLoader wasSentToResourcePath:@"/signup"]) {
		// Sign Up failed
		if ([self.delegate respondsToSelector:@selector(user:didFailSignUpWithError:)]) {
			[self.delegate user:self didFailSignUpWithError:error];
		}
	}
}

- (BOOL)isLoggedIn {
	return self.singleAccessToken != nil;
}
/*
- (BOOL)canModifyObject:(DBContentObject*)object {
	if ([object isNewRecord]) {
		return YES;
	} else if ([self isLoggedIn] && [self isEqual:object.user]) {
		return YES;
	} else {
		return NO;
	}
}
*/
- (void)dealloc {
	_delegate = nil;
	[_password release];
	[_passwordConfirmation release];
	[super dealloc];
}

@end
