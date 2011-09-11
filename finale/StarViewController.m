

#import "StarViewController.h"
#import "Star.h"
#import "SLUser.h"


@implementation StarViewController

@synthesize star = _star;
@synthesize thisUser = _thisUser;


- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
	if (self = [super initWithNavigatorURL:URL query:query]) {
		_star = [[Star object] retain];
		_star.name = @"";
	}
	
	return self;
}

- (id)initWithStarID:(NSString*)starID {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		_star = [[Star findFirstByAttribute:@"starID" withValue:starID] retain];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_star);
	[super dealloc];
}

- (void)viewDidUnload {
	TT_RELEASE_SAFELY(_starNameField);
}

- (void)loadView {
	[super loadView];
	
	self.tableViewStyle = UITableViewStyleGrouped;
	
//	if (![self.star isNewRecord]) {
//		// Ensure we are logged in as the User who created the Topic
//		self.requiredUser = self.star.user;
//	}
 
	[self presentLoginViewControllerIfNecessary];

	_starNameField = [[UITextField alloc] initWithFrame:CGRectZero];
	_starNameField.placeholder = @"Star name";

    
    _xCoordField = [[UITextField alloc] initWithFrame:CGRectZero];
    
	_xCoordField.placeholder = @"X Coordinates";
    _yCoordField = [[UITextField alloc] initWithFrame:CGRectZero];
	_yCoordField.placeholder = @"Y Coordinates";

}

- (void)createModel {
	NSMutableArray* items = [NSMutableArray array];

	_starNameField.text = self.star.name;
	[items addObject:[TTTableControlItem itemWithCaption:@"Name" control:_starNameField]];
    [items addObject:[TTTableControlItem itemWithCaption:@"X" control:_xCoordField]];
    [items addObject:[TTTableControlItem itemWithCaption:@"Y" control:_yCoordField]];


	if ([self.star isNewRecord]) {
		self.title = @"New Star";
		[items addObject:[TTTableButton itemWithText:@"Create" delegate:self selector:@selector(createButtonWasPressed:)]];

	
    } else { 
		self.title = @"Edit Star";
		[items addObject:[TTTableButton itemWithText:@"Update" delegate:self selector:@selector(updateButtonWasPressed:)]];
		[items addObject:[TTTableButton itemWithText:@"Delete" delegate:self selector:@selector(destroyButtonWasPressed:)]];
	}
	
	self.dataSource = [TTListDataSource dataSourceWithItems:items];
}

#pragma mark Actions

- (void)createButtonWasPressed:(id)sender {
	self.star.name = _starNameField.text;

    
//Have to convert from .text to NSNumber

    NSNumber* copy = (NSNumber*)_xCoordField.text;
    NSNumber* copy2 = (NSNumber*)_yCoordField.text ;

   
    self.star.XCoord = copy;
	self.star.YCoord = copy2;
  
    self.star.userID = self.thisUser.userID;

	[[RKObjectManager sharedManager] postObject:self.star delegate:self];
}

- (void)updateButtonWasPressed:(id)sender {
	self.star.name = _starNameField.text;
	[[RKObjectManager sharedManager] putObject:self.star delegate:self];
}

- (void)destroyButtonWasPressed:(id)sender {
	[[RKObjectManager sharedManager] deleteObject:self.star delegate:self];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	// Post notification telling view controllers to reload.
//	[[NSNotificationCenter defaultCenter] postNotificationName:DBContentObjectDidChangeNotification object:[objects lastObject]];
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	[[[[UIAlertView alloc] initWithTitle:@"Error" 
								 message:[error localizedDescription] 
								delegate:nil 
					   cancelButtonTitle:@"OK" 
					   otherButtonTitles:nil] autorelease] show];
}

@end
