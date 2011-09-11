

#import "allStarsTableController.h"
#import "MockDataSource.h"
#import "Star.h"
#import "SLUser.h"

@implementation allStarsTableController


- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if (self = [super initWithNavigatorURL:URL query:query]) {
		self.title = @"Stars";
    }
	return self;
}



- (void)createModel {
    /**
     Map loaded objects into Three20 Table Item instances!
     */
    RKObjectTTTableViewDataSource* dataSource = [RKObjectTTTableViewDataSource dataSource];
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[TTTableTextItem class]];
    [mapping mapKeyPath:@"name" toAttribute:@"text"];
    [mapping mapKeyPath:@"starNavURL" toAttribute:@"URL"];
    [dataSource mapObjectClass:[Star class] toTableItemWithMapping:mapping];
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:@"/stars" delegate:nil];
    dataSource.model = [RKObjectLoaderTTModel modelWithObjectLoader:objectLoader];
    self.dataSource = dataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // On subsequent appearances, refresh the table
    if (self.model) {
        [self createModel];
    }
}



- (void)updateLogoutButton {
    UIBarButtonItem* item = nil;
    if ([[SLUser currentUser] isLoggedIn]) {
		item = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonWasPressed:)];
	}
	self.navigationItem.leftBarButtonItem = item;
    [item release];
}


- (void)loadView {
    [super loadView];
    
//	[self updateLogoutButton];
if ([[SLUser currentUser] isLoggedIn]) {    
	UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage* newButtonImage = [UIImage imageNamed:@"add.png"];
	[newButton setImage:newButtonImage forState:UIControlStateNormal];
	[newButton addTarget:self action:@selector(addButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	[newButton setFrame:CGRectMake(0, 0, newButtonImage.size.width, newButtonImage.size.height)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonWasPressed:)];	
}
}

- (void)addButtonWasPressed:(id)sender {
	TTOpenURL(@"tt://stars/new");
}

- (void)logoutButtonWasPressed:(id)sender {
	[[SLUser currentUser] logout];
}
 


- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];
    
	if ([self.model isKindOfClass:[RKObjectLoaderTTModel class]]) {
		RKObjectLoaderTTModel* model = (RKObjectLoaderTTModel*)self.model;
        
		NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
		[formatter setDateFormat:@"hh:mm:ss MM/dd/yy"];
		_loadedAtLabel.text = [formatter stringFromDate:model.loadedTime];
	}
}

@end


