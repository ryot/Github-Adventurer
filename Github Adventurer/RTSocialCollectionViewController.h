//
//  RTSocialCollectionViewController.h
//  Github Adventurer
//
//  Created by Ryo Tulman on 4/24/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTRootMenuButtonProtocol.h"

@interface RTSocialCollectionViewController : UIViewController

@property (nonatomic, unsafe_unretained) id<RTRootMenuButtonProtocol> rootDelegate;

@end
