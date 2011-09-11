//
//  baseController.m
//  finale
//
//  Created by Zzbg on 8/29/11.
//  Copyright 2011 NYU. All rights reserved.
//

#import "baseController.h"

@implementation baseController

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Base View";
        self.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@"Base" style:UIBarButtonItemStyleBordered
                                         target:nil action:nil] autorelease];
        
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTModelViewController

- (void)createModel {
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"Stars",

                       [TTTableTextItem itemWithText:@"All Stars" URL:@"tt://stars"], nil];
}

@end
