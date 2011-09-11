
extern NSString* const StarBaseURL;

/**
 * Server Environments for conditional compilation
 */
#define DB_ENVIRONMENT_DEVELOPMENT 0
#define DB_ENVIRONMENT_STAGING 1
#define DB_ENVIRONMENT_PRODUCTION 2

// Use Production by default
#ifndef DB_ENVIRONMENT
#define DB_ENVIRONMENT DB_ENVIRONMENT_PRODUCTION
#endif
