//
//  RTRepoDetailViewController.h
//  Github Adventurer
//
//  Created by Ryo Tulman on 3/17/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repo.h"

@interface RTRepoDetailViewController : UIViewController

@property (nonatomic,strong) Repo *thisRepo;
@property (weak, nonatomic) IBOutlet UIWebView *repoWebView;

@end
