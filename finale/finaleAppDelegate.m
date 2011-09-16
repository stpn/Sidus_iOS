//
//  finaleAppDelegate.m
//  finale
//
//  Created by Zzbg on 8/26/11.
//  Copyright 2011 NYU. All rights reserved.
//

#import "finaleAppDelegate.h"
#import "baseController.h"
#import "allStarsTableController.h"
#import "SplitCatalogController.h"
#import "DBLoginOrSignUpViewController.h"
#import "StarViewController.h"
#import "TabBarController.h"


//DRAWING:
#import "TouchDrawView.h"
#import "Line.h"
#import "TouchDrawView.h"
#import "MainViewController.h"
#import "ARRViewController.h"



//MODELS:
#import "Star.h"
#import "SLUser.h"

//RESTKIT:

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>
#import <RestKit/Support/JSON/JSONKit/RKJSONParserJSONKit.h>
#import <RestKit/Support/JSON/SBJSON/RKJSONParserSBJSON.h>
#import <RestKit/Support/JSON/YAJL/RKJSONParserYAJL.h>
#import "DBManagedObjectCache.h"

/**
 * The HTTP Header Field we transmit the authentication token obtained
 * during login/sign-up back to the server. This token is verified server
 * side to establish an authenticated session
 */
static NSString* const kDBAccessTokenHTTPHeaderField = @"X-USER-ACCESS-TOKEN";





@implementation finaleAppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
	// Initialize the RestKit Object Manager
	RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:StarBaseURL];
    
	// Set the default refresh rate to 1. This means we should always hit the web if we can.
	// If the server is unavailable, we will load from the Core Data cache.
	[RKObjectLoaderTTModel setDefaultRefreshRate:1];
    
	// Initialize object store
	// We are using the Core Data support, so we have initialized a managed object store backed
	// with a SQLite database. We are also utilizing the managed object cache support to provide
	// offline access to locally cached content.
	objectManager.objectStore = [[[RKManagedObjectStore alloc] initWithStoreFilename:@"Stars3.sqlite"] autorelease];
    objectManager.objectStore.managedObjectCache = [[DBManagedObjectCache new] autorelease];

    
//USER MAPPING:

  
    RKManagedObjectMapping* userMapping = [RKManagedObjectMapping mappingForClass:[SLUser class]];
    userMapping.primaryKeyAttribute = @"userID";
    userMapping.setDefaultValueForMissingAttributes = YES; // clear out any missing attributes (token on logout)
    [userMapping mapKeyPathsToAttributes:
     @"id", @"userID",
     @"email", @"email",
     @"username", @"username",
     @"single_access_token", @"singleAccessToken",
     @"password", @"password",
     @"password_confirmation", @"passwordConfirmation",
     nil];
    
    
    
    
    RKManagedObjectMapping* starMapping = [RKManagedObjectMapping mappingForClass:[Star class]];
 
    starMapping.primaryKeyAttribute = @"starID";
    
     [starMapping mapKeyPathsToAttributes:
     @"id", @"starID",
     @"user_id", @"userID",
     @"name", @"name",
     @"created_at", @"createdAt",
     @"updated_at", @"updatedAt",
     @"x_coord", @"XCoord",
     @"y_coord", @"YCoord",
     nil];
    
    
    [starMapping mapRelationship:@"user" withMapping:userMapping];
    [objectManager.mappingProvider registerMapping:userMapping withRootKeyPath:@"user"];
    [objectManager.mappingProvider registerMapping:starMapping withRootKeyPath:@"star"];

  
    [objectManager.router routeClass:[SLUser class] toResourcePath:@"/signup" forMethod:RKRequestMethodPOST];
	[objectManager.router routeClass:[SLUser class] toResourcePath:@"/login" forMethod:RKRequestMethodPUT];
    
    
    [objectManager.router routeClass:[Star class] toResourcePath:@"/stars" forMethod:RKRequestMethodGET];
	[objectManager.router routeClass:[Star class] toResourcePath:@"/stars" forMethod:RKRequestMethodPOST];
	[objectManager.router routeClass:[Star class] toResourcePath:@"/stars/(starID)" forMethod:RKRequestMethodPUT];
	[objectManager.router routeClass:[Star class] toResourcePath:@"/stars/(starID)" forMethod:RKRequestMethodDELETE];

    
    
    /**
     Configure RestKit Logging
     
     RestKit ships with a robust logging framework that can be used to instrument
     the libraries activities in great detail. Logging is configured by specifying a
     logging component and a log level to use for that component.
     
     By default, RestKit is configured to log at the Info or Warning levels for all components
     depending on the presence of the DEBUG pre-processor macro. This can be configured at run-time
     via calls to RKLogConfigureByName as detailed below.
     
     See RKLog.h and lcl_log_components.h for details on the logging macros available
     */    
    RKLogConfigureByName("RestKit", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Network", RKLogLevelDebug);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
    RKLogConfigureByName("RestKit/Network/Queue", RKLogLevelDebug);
    
    // Enable boatloads of trace info from the mapper
     RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    /**
     Enable verbose logging for the App component. 
     
     This component is exported by RestKit to allow you to leverage the same logging
     facilities and macros in your app that are used internally by the library. When
     you #import <RestKit/RestKit.h>, the default logging component is set to 'App'
     for you. Calls to RKLog() within your application will log at the level specified below.
     */
    RKLogSetAppLoggingLevel(RKLogLevelTrace);
    
    RKLogDebug(@"Stars are loading...");
    
	// Initialize Three20 : Comes from below:
    //////// Initialize Three20

    TTNavigator* navigator = [TTNavigator navigator];
    navigator.supportsShakeToReload = YES;
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
    navigator.window = [[[UIWindow alloc] initWithFrame:TTScreenBounds()] autorelease];

    
    
    TTURLMap* map = navigator.URLMap;
    [map from:@"*" toViewController:[TTWebController class]];
    
    
    if (TTIsPad()) {
        [map from: @"tt://base" toSharedViewController: [SplitCatalogController class]];
        
        
        SplitCatalogController* controller =  (SplitCatalogController*)[[TTNavigator navigator] viewControllerForURL:@"tt://base"];
        TTDASSERT([controller isKindOfClass:[SplitCatalogController class]]);
        map = controller.rightNavigator.URLMap;
        
    } else {
        [map from: @"tt://base" toSharedViewController: [baseController class]];
    }
	
    

    [map from:@"tt://tabBar" toSharedViewController:[TabBarController class]];




    [map from:@"tt://stars" parent: @"tt://base" toViewController:[allStarsTableController class] selector: nil transition: 0];
	[map from:@"tt://stars/new" toViewController:[StarViewController class]];
    
    [map from:@"tt://stars/(initWithStarID:)/" toViewController:[StarViewController class]];
    [map from:@"tt://stars/(initWithStarID:)/edit" toViewController:[StarViewController class]];


    
    [map from:@"tt://Drawing" toSharedViewController:[ARRViewController class]];

    
	[map from:@"tt://login" toModalViewController:[DBLoginOrSignUpViewController class]];

    
    [[TTURLRequestQueue mainQueue] setMaxContentLength:0]; // Don't limit content length.	
    
    if (![navigator restoreViewControllers]) {
        [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://tabBar"]];
    }
/////////////////////////Three20 ENDS
    
    
//AUTHENTICATION:    
    // Register for authentication notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAccessTokenHeaderFromAuthenticationNotification:) name:SLUserDidLoginNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAccessTokenHeaderFromAuthenticationNotification:) name:SLUserDidLogoutNotification object:nil];

    // Initialize authenticated access if we have a logged in current User reference
	SLUser* user = [SLUser currentUser];
	if ([user isLoggedIn]) {
		RKLogInfo(@"Found logged in User record for username '%@' [Access Token: %@]", user.username, user.singleAccessToken);
		[objectManager.client setValue:user.singleAccessToken forHTTPHeaderField:kDBAccessTokenHTTPHeaderField];
	}

    
    TTOpenURL(@"tt://tabBar");
	[[TTNavigator navigator].window makeKeyAndVisible];
  
    
	return YES;
    
}   

// Watch for login/logout events and set the Access Token HTTP Header
- (void)setAccessTokenHeaderFromAuthenticationNotification:(NSNotification*)notification {
	SLUser* user = (SLUser*) [notification object];
	RKObjectManager* objectManager = [RKObjectManager sharedManager];
	[objectManager.client setValue:user.singleAccessToken forHTTPHeaderField:kDBAccessTokenHTTPHeaderField];
}

    
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
    return YES;
}

    
@end
