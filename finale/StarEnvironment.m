

#import "StarEnvironment.h"

// Base URL
#if DB_ENVIRONMENT == DB_ENVIRONMENT_DEVELOPMENT
NSString* const StarBaseURL = @"http://localhost:3000";

//	NSString* const StarBaseURL = @"http://smooth-light-412.heroku.com";
#elif DB_ENVIRONMENT == DB_ENVIRONMENT_STAGING
	// TODO: Need a staging environment...
#elif DB_ENVIRONMENT == DB_ENVIRONMENT_PRODUCTION
//	NSString* const StarBaseURL = @"http://smooth-light-412.heroku.com";
NSString* const StarBaseURL = @"http://localhost:3000";
#endif
