

#import "DBManagedObjectCache.h"
#import "Star.h"

@implementation DBManagedObjectCache

- (NSArray*)fetchRequestsForResourcePath:(NSString*)resourcePath {
	if ([resourcePath isEqualToString:@"/stars"]) {
		NSFetchRequest* request = [Star fetchRequest];
		NSSortDescriptor* sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES] autorelease];
		[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		return [NSArray arrayWithObject:request];
	}
/*	
	// match on /topics/:id/posts
	NSArray* components = [resourcePath componentsSeparatedByString:@"/"];
	if ([components count] == 4 &&
		[[components objectAtIndex:1] isEqualToString:@"stars"]) 
//        &&
//		[[components objectAtIndex:3] isEqualToString:@"posts"]) 
    {
		NSString* starIDString = [components objectAtIndex:2];
		NSNumber* starID = [NSNumber numberWithInt:[starIDString intValue]];
		NSFetchRequest* request = [Star fetchRequest];
		NSPredicate* predicate = [NSPredicate predicateWithFormat:@"topicID = %@", topicID, nil];
		[request setPredicate:predicate];
		NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES];
		[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		return [NSArray arrayWithObject:request];
        
	}
*/
	return nil;
}

@end
