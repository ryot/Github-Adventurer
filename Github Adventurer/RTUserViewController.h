//
//  RTUserViewController.h
//  Github Adventurer
//
//  Created by Ryo Tulman on 4/21/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTRootMenuButtonProtocol.h"

@interface RTUserViewController : UIViewController

@property (nonatomic, unsafe_unretained) id<RTRootMenuButtonProtocol> rootDelegate;

@end
