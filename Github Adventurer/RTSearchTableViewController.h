//
//  RTRepoTableViewController.h
//  Github Adventurer
//
//  Created by Ryo Tulman on 3/17/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTRootMenuButtonProtocol.h"

@interface RTSearchTableViewController : UITableViewController

@property (nonatomic, unsafe_unretained) id<RTRootMenuButtonProtocol> rootDelegate;

@end
