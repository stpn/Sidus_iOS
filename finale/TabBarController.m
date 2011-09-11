
#import "TabBarController.h"

@implementation TabBarController

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)viewDidLoad {
    [self setTabURLs:[NSArray arrayWithObjects:@"tt://stars",
                      @"tt://login",
                      @"tt://Drawing",
                      nil]];
}

@end

