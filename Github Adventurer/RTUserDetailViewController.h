//
//  RTUserDetailViewController.h
//  Github Adventurer
//
//  Created by Ryo Tulman on 4/24/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GithubUser.h"

@interface RTUserDetailViewController : UIViewController

@property (nonatomic,strong) GithubUser *thisUser;
@property (weak, nonatomic) IBOutlet UIWebView *userWebView;

@end
